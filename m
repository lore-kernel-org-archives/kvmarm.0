From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH 1/2] kvm: Fix mmu_notifier release race
Date: Wed, 26 Apr 2017 17:03:44 +0100
Message-ID: <c1232b1d-ad82-794b-1b86-4d0cc0d4cd7f@arm.com>
References: <1493028624-29837-1-git-send-email-suzuki.poulose@arm.com>
 <1493028624-29837-2-git-send-email-suzuki.poulose@arm.com>
 <20170425184904.GI5713@potion>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170425184904.GI5713@potion>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: pbonzini@redhat.com, christoffer.dall@linaro.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, mark.rutland@arm.com, andreyknvl@google.com, Will Deacon <Will.Deacon@arm.com>, paulmck@linux.vnet.ibm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 25/04/17 19:49, Radim Krčmář wrote:
> 2017-04-24 11:10+0100, Suzuki K Poulose:
>> The KVM uses mmu_notifier (wherever available) to keep track
>> of the changes to the mm of the guest. The guest shadow page
>> tables are released when the VM exits via mmu_notifier->ops.release().
>> There is a rare chance that the mmu_notifier->release could be
>> called more than once via two different paths, which could end
>> up in use-after-free of kvm instance (such as [0]).
>>
>> e.g:
>>
>> thread A                                        thread B
>> -------                                         --------------
>>
>>  get_signal->                                   kvm_destroy_vm()->
>>  do_exit->                                        mmu_notifier_unregister->
>>  exit_mm->                                        kvm_arch_flush_shadow_all()->
>>  exit_mmap->                                      spin_lock(&kvm->mmu_lock)
>>  mmu_notifier_release->                           ....
>>   kvm_arch_flush_shadow_all()->                   .....
>>   ... spin_lock(&kvm->mmu_lock)                   .....
>>                                                   spin_unlock(&kvm->mmu_lock)
>>                                                 kvm_arch_free_kvm()
>>    *** use after free of kvm ***
>
> I don't understand this race ...
> a piece of code in mmu_notifier_unregister() says:
>
>   	/*
>   	 * Wait for any running method to finish, of course including
>   	 * ->release if it was run by mmu_notifier_release instead of us.
>   	 */
>   	synchronize_srcu(&srcu);
>
> and code before that removes the notifier from the list, so it cannot be
> called after we pass this point.  mmu_notifier_release() does roughly
> the same and explains it as:
>
>   	/*
>   	 * synchronize_srcu here prevents mmu_notifier_release from returning to
>   	 * exit_mmap (which would proceed with freeing all pages in the mm)
>   	 * until the ->release method returns, if it was invoked by
>   	 * mmu_notifier_unregister.
>   	 *
>   	 * The mmu_notifier_mm can't go away from under us because one mm_count
>   	 * is held by exit_mmap.
>   	 */
>   	synchronize_srcu(&srcu);
>
> The call of mmu_notifier->release is protected by srcu in both cases and
> while it seems possible that mmu_notifier->release would be called
> twice, I don't see a combination that could result in use-after-free
> from mmu_notifier_release after mmu_notifier_unregister() has returned.

Thanks for bringing it up. Even I am wondering why this is triggered ! (But it
does get triggered for sure !!)

The only difference I can spot with _unregister & _release paths are the way
we use src_read_lock across the deletion of the entry from the list.

In mmu_notifier_unregister() we do :

                 id = srcu_read_lock(&srcu);
                 /*
                  * exit_mmap will block in mmu_notifier_release to guarantee
                  * that ->release is called before freeing the pages.
                  */
                 if (mn->ops->release)
                         mn->ops->release(mn, mm);
                 srcu_read_unlock(&srcu, id);

## Releases the srcu lock here and then goes on to grab the spin_lock.

                 spin_lock(&mm->mmu_notifier_mm->lock);
                 /*
                  * Can not use list_del_rcu() since __mmu_notifier_release
                  * can delete it before we hold the lock.
                  */
                 hlist_del_init_rcu(&mn->hlist);
                 spin_unlock(&mm->mmu_notifier_mm->lock);

While in mmu_notifier_release() we hold it until the node(s) are deleted from the
list :
         /*
          * SRCU here will block mmu_notifier_unregister until
          * ->release returns.
          */
         id = srcu_read_lock(&srcu);
         hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist)
                 /*
                  * If ->release runs before mmu_notifier_unregister it must be
                  * handled, as it's the only way for the driver to flush all
                  * existing sptes and stop the driver from establishing any more
                  * sptes before all the pages in the mm are freed.
                  */
                 if (mn->ops->release)
                         mn->ops->release(mn, mm);

         spin_lock(&mm->mmu_notifier_mm->lock);
         while (unlikely(!hlist_empty(&mm->mmu_notifier_mm->list))) {
                 mn = hlist_entry(mm->mmu_notifier_mm->list.first,
                                  struct mmu_notifier,
                                  hlist);
                 /*
                  * We arrived before mmu_notifier_unregister so
                  * mmu_notifier_unregister will do nothing other than to wait
                  * for ->release to finish and for mmu_notifier_unregister to
                  * return.
                  */
                 hlist_del_init_rcu(&mn->hlist);
         }
         spin_unlock(&mm->mmu_notifier_mm->lock);
         srcu_read_unlock(&srcu, id);

## The lock is release only after the deletion of the node.

Both are followed by a synchronize_srcu(). Now, I am wondering if the unregister path
could potentially miss SRCU read lock held in _release() path and go onto finish the
synchronize_srcu before the item is deleted ? May be we should do the read_unlock
after the deletion of the node in _unregister (like we do in the _release()) ?

>
> Doesn't [2/2] solve the exact same issue (that the release method cannot
> be called twice in parallel)?

Not really. This could be a race between a release() and one of the other notifier
callbacks. e.g, In [0], we were hitting a use-after-free in kvm_unmap_hva() where,
the unregister could have succeeded and released the KVM.


[0] http://lkml.kernel.org/r/febea966-3767-21ff-3c40-1a76d1399138@suse.de

In effect this all could be due to the same reason, the synchronize in unregister
missing another reader.

Suzuki

>
> Thanks.
>
