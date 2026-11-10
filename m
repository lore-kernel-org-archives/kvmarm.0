Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794314960;
	b=QInRCRh04ZXG9a9emsRKDQhytMRm4O118XAxE4XW5GoJMQZ4bWA4p+TA8uuOl9rFbbNK
	 INQoQxp16M4J0KrZ1pgmrKK9qU+gvPfzPvcdilhjpcUXAJez41bTBnMh6Z3YzFBSlHvK+
	 KI4+pdicb9uxlLOaVowtFiw6LlrZeKVYOev2lrGGS0bQfLwF/L+kePGWpEJ/ZkHzvh3NB
	 iz/LYFPu31U1klKqiJJASLFoKsxIU351tnIWBsYmVkpS4twg7kt4xJ2Y0aoNqbarEUlet
	 jDCmuzFQJSFzoydHoPN72hp+q5SSatcK3yhJuWVxEjz7QeE2JxAZ5ZsjyXUIzwMWYXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794314960;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=CbaK/OiLsBp24ctmmqfxEDeKLJHZS6Yzb8a5ARPuJDc=;
	b=pmtbRa9MxqCmhYy8DL34oHqGpMlMHJCM0D8VogslEEp2OKVj8blGfYlBEpdXPD9tXnet
	 QHpT8sd3cxQyKi9Aqt5UKjG9ydd1vlx52sUgL4vGPejwN4591Q74qd85LV3QsZGgKuDb6
	 n1BMKCWICEaXGCm2HbZHfFLYQP3I+8B38Tr/1NSJs6s11FgHSiX6eOFDU/v+Q9lF4r44F
	 lwCoXCHMAncuSQ8PhX7BIgkEL+RS20b3k+4S/WLeaNjFv8EdvncdzG12g4Kj5igr6Xu7y
	 EOmkdiXuddbxYPlSZ5dzoNW8HlQa6x4/B/+6PYsq3inxFeFP+/29A5LRATOjVJrJLcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="FW4jWPq/";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99D08606A338
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 12:49:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99D08606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=FW4jWPq/
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C64A514BF;
	Tue, 10 Nov 2026 04:49:14 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8EE773F85F;
	Tue, 10 Nov 2026 04:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794314957; bh=P5lO3LRwfz3Xx9spMdnYq5HZgom/q8jT5u8waDgtbsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FW4jWPq/tfDZxBG7gTvwO6Saghy4qPGyV+hze///XZNsFLtYaK5wj2gUsAQ3b/1gh
	 T6W5B9h4lNu/oIbpkFS2CPsomzXXZPsB1rdaGrB44ze6FvmHsifyDOH/BV74iyXiQD
	 /n5r91Z2/5jv4DVU8iWFUs+t19uEOqOgbofPVNlY=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	corbet@lwn.net,
	pbonzini@redhat.com,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com,
	caijian11@h-partners.com,
	liuyonglong@huawei.com,
	tangchengchang@huawei.com,
	yezhenyu2@huawei.com,
	yubihong@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	fuad.tabba@linux.dev,
	mark.rutland@arm.com,
	seanjc@google.com,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH v5 11/15] KVM: arm64: Reserve dirty ring space for the HDBSS buffer
Date: Tue, 10 Nov 2026 12:49:07 +0000
Message-ID: <avMSw3LLDIFT3kSR@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <90775cb3-84ab-4690-a252-1ac41488118f@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com> <20260929103655.85107-12-zhengtian10@huawei.com> <auikG0clmr19sAjh@LeoBrasDK> <afcbf19b-bd13-4afc-ab56-8bc50c793e50@huawei.com> <au30DqzWIFny1tpr@LeoBrasDK> <d81243e3-d790-4ee8-9b28-36d35591ee77@huawei.com> <avIOZTvQF-1sxs2p@LeoBrasDK> <90775cb3-84ab-4690-a252-1ac41488118f@huawei.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Nov 10, 2026 at 04:54:30PM +0800, Tian Zheng wrote:
> 
> 
> On 11/10/2026 2:18 AM, Leonardo Bras wrote:
> > On Mon, Nov 09, 2026 at 12:00:52PM +0800, Tian Zheng wrote:
> > > 
> > > 
> > > On 11/6/2026 11:36 PM, Leonardo Bras wrote:
> > > > On Fri, Nov 06, 2026 at 06:36:04PM +0800, Tian Zheng wrote:
> > > > > 
> > > > > 
> > > > > On 11/2/2026 10:54 PM, Leonardo Bras wrote:
> > > > > > On Tue, Sep 29, 2026 at 06:36:51PM +0800, Tian Zheng wrote:
> > > > > > > The dirty ring reserves room for CPU-side dirty buffers via
> > > > > > > kvm_cpu_dirty_log_size(). Report the HDBSS buffer entry count
> > > > > > > through it, so a full buffer flush always fits in the ring.
> > > > > > > 
> > > > > > > Pin the HDBSS buffer size to PAGE_SIZE when dirty-ring is enabled,
> > > > > > > via kvm_arch_dirty_ring_size_updated(): a larger buffer only
> > > > > > > shrinks the soft_limit and forces more frequent userspace drains.
> > > > > > > 
> > > > > > > Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> > > > > > > ---
> > > > > > >     arch/arm64/kvm/arm.c | 8 ++++++++
> > > > > > >     arch/arm64/kvm/mmu.c | 8 ++++++++
> > > > > > >     2 files changed, 16 insertions(+)
> > > > > > > 
> > > > > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > > > > index 9d7bdece149a..5a7046acb62e 100644
> > > > > > > --- a/arch/arm64/kvm/arm.c
> > > > > > > +++ b/arch/arm64/kvm/arm.c
> > > > > > > @@ -215,6 +215,14 @@ static int kvm_arm_default_max_vcpus(void)
> > > > > > >     	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
> > > > > > >     }
> > > > > > > 
> > > > > > > +void kvm_arch_dirty_ring_size_updated(struct kvm *kvm)
> > > > > > > +{
> > > > > > > +	if (!system_supports_hdbss())
> > > > > > > +		return;
> > > > > > > +
> > > > > > > +	kvm->arch.hdbss_buffer_size = KVM_ARM_HDBSS_DEFAULT_SIZE;
> > > > > > > +}
> > > > > > > +
> > > > > > 
> > > > > > On the same subject as a previous patch:
> > > > > > I don't think this is the best approach, on top of adding a new weak
> > > > > > function to take care.
> > > > > > 
> > > > > > Maybe during the dirty-ring allocation, on vcpu creation, we could take
> > > > > > into account the requested dirty-ring size, and just allocate the HDBSS
> > > > > > buffer taking that into account. That would make it simpler, don't you
> > > > > > agree?
> > > > > > 
> > > > > > Thanks!
> > > > > > Leo
> > > > > 
> > > > > Hi Leo,
> > > > > 
> > > > > The "set once" guard we're discussing comes from the patch that adds the
> > > > > ioctl, and it isn't really needed. We discussed this earlier [1]: we can
> > > > > just initialize hdbss_buffer_size to PAGE_SIZE at VM creation and let
> > > > > the ring reservation use it directly. **That also means
> > > > > kvm_arch_dirty_ring_size_updated() can be removed.** Thanks for your
> > > > > suggestion.
> > > > 
> > > > :)
> > > > 
> > > > > 
> > > > > As for why PAGE_SIZE is the right value in ring mode: the HDBSS buffer
> > > > > is flushed on every VM exit, so a larger buffer doesn't reduce the flush
> > > > > frequency. It only inflates the ring reservation (64 + size/
> > > > > sizeof(u64)), which shrinks the soft_limit and forces more frequent
> > > > > exits to userspace for the ring to be drained. Draining the dirty ring
> > > > > from QEMU is more expensive than draining the HDBSS buffer from the
> > > > > kernel, so the smallest buffer gives the best performance. In this mode,
> > > > > a larger buffer provides no benefit to users.
> > > > 
> > > > Humm, if properly dimensioned larger buffers would be benefitial for
> > > > memory-intensive workloads, unless they are guest_exiting for other
> > > > reasons in the meantime.
> > > > 
> > > 
> > > Agreed, and the workload I tested is on the "unless" side. The guest
> > > exits constantly for other reasons, so the larger buffer never got a
> > > chance to pay off, and only cost ring capacity.
> > > 
> > > > > 
> > > > > In my tests, I also saw performance degrade when more space is reserved.
> > > > > 
> > > > 
> > > > Humm, what kind of workloads did you test?
> > > > Did you have the chance to monitor what were the reasons for VM exiting?
> > > > 
> > > 
> > > For the workload question, it's a Redis server in the guest under redis-
> > > benchmark (SET-only, 2KB values, 1M keys, 100M requests). The traffic is
> > > network-driven, so the guest exits constantly to service requests. The
> > > HDBSS buffer only accumulates entries between two exits and is flushed
> > > on every exit, so it rarely fills regardless of size. A larger buffer
> > > only inflated the ring reservation, which shrinks the soft_limit and
> > > makes the ring-full exit and userspace drain fire more often.
> > > 
> > > > I am not saying this is mandatory for the HDBSS implementation, but the
> > > > whole idea of letting the user choose their own HDBSS buffer size is
> > > > because different workloads may benefit from different buffer sizes: if a
> > > > VM writes a lot to new memory, and exits very little for other reasons,
> > > > then a larger buffer will cause the VM to guest_exit much less often.
> > > > 
> > > > Does that make sense?
> > > > 
> > > > Thanks!
> > > > Leo
> > > 
> > > It does make sense. That's exactly the workload where a larger buffer
> > > pays off, and the next version no longer gets in its way. The two ioctls
> > > are no longer mutually exclusive.
> > > 
> > > The only coupling left is the reservation. hdbss_buffer_size starts at
> > > SZ_4K at VM creation, so a ring enabled right away reserves for the
> > > default buffer (64 + 512 entries), and the minimum ring size accepted is
> > > unchanged from v5. KVM_CAP_ARM_HDBSS_BUFFER_SIZE is the gate. When the
> > > ring is already enabled, a size is accepted only if its reservation
> > > still fits in the ring, otherwise -EINVAL. In the other order, ring-
> > > enable validation rejects a ring too small for the configured size.
> > 
> > I don't think this is needed. If using dirtyring, we don't need to allow
> > user to set hdbss size: HDBSS size should be sized according to the
> > dirty-ring dimensions, that are set by userspace before the first vcpu is
> > created.
> > 
> > 
> > > So SZ_4K is just the conservative default for guests that exit often.
> > > Anything larger, within what the ring can reserve, is up to the user.
> > > 
> > > Does this work for you?
> > 
> > I still think we should do PAGE_SIZE for dirty-bitmap. Dirty ring should do
> > based on the dirty-ring size, and maybe review the use of reserved
> > entries, or it's accounting.
> > 
> > What do you think?
> > 
> > Thanks!
> > Leo
> 
> Hi Leo,
> 
> Thanks for your review. It does make sense!
> 
> I agree that dirty-bitmap mode will keep PAGE_SIZE as the default, and
> in that mode the ioctl stays available for a larger buffer.
> 
> In ring mode we will drop the ioctl, the two remain mutually exclusive,
> and the buffer will be derived from the ring size userspace configured
> before the first vCPU is created:
> 
> ```
> hdbss_buffer = clamp_t(unsigned long,
>                        rounddown_pow_of_two(ring_size / 16),
>                        SZ_4K, KVM_ARM_HDBSS_MAX_SIZE);
> ```
> 

Are you allocating 1/16th of the ring size in bytes as an hdbss buffer?
That's confusing. I recommend we rather have something like:

ring_entries = ring_size / sizeof(struct kvm_dirty_gfn);
hdbss_entries = ring_entries / 2; // Or any number we decide to use here.
hdbss_buf_size = hdbss_entries * sizeof(hdbss_buf_entry);

Then we do 
hdbss_buf_size = clamp_t(unsigned long,
                         rounddown_pow_of_two(hdbss_buf_size),
                         SZ_4K, KVM_ARM_HDBSS_MAX_SIZE);

So it's clear what is what here. 
Just dividing by 16 above can be confusing to whoever is reading the code.


> A buffer entry is 8 bytes and a ring entry is 16 bytes, so:
> 
> ```
> buffer entries = buffer_size / 8
> ring entries   = ring_size / 16
> ```

Remember to use the sizeof instead of fixed numbers.

> 
> This means ring_size / 16 reserves at most one eighth of the ring
> entries for the HDBSS buffer. That keeps the usable ring above 85% while
> the buffer still grows with the configured ring size, and the result is
> independent of the kernel page size, with SZ_4K as the only minimum.

Yeah, remember that if you are dealing with the ringbuffer like this, an 
user can request a 4k ringbuffer and we just won't be able to use hdbss, as 
it means 4k/16 entries, and hdbss has the minimum of 4k/8.

As I mentioned, maybe this approach of reserved entries is not the right 
way of dealing with it in arm64.

> 
> One eighth is the ratio that looks reasonable to me so far. What do you
> think?
> 

I see no reason why it could not be higher than that. It all depends on how 
you want to deal with the full buffer in the future patchset. If hdbss 
buffer is full, it has to exit and drain to the dirtyring. The guarantee 
you seek with reserved entries is that all hdbss entries fit in the 
dirty-ring.

As long as the user is required to drain entries until the dirty-ring is 
not 'full' anymore, we could easily work with dirty-ring having twice as 
many entries as the hdbss buffer.

How does it sound?

Thanks!
Leo

