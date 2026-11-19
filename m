Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795111271;
	b=lE2fufJd0dPZammB1PaBLXO7QhmHwCodqWyGK30dFNnoXyHwnkYJLFy9jmcraUH74PP+
	 yQaFC4asbp948yx8StXb/Uyf/ZIwfWzLU3ItdbxyJLV7W5SypqXcJWuEfuzcqh3Bz15ww
	 vmtxXqIVV1PR+eNFikvI8QDrQlW/kE0fidm618DgKnkv99/IDUQc7nbq5tgtEo+zgHH8T
	 jCE7WWm1vQrI1TTiN9Pe4RF6yv2HVWkYAoFSmprrIGbAS3lZFmttP9n4VRS8c0rNTedJJ
	 zTcpvz4/PYHZi/CgYYK2tdcS18Omo2SMqTaBU/KveWIzq3dd0Nmg75tjR3/lC6783HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795111271;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=2rnElIWK3bcjP3PPdpFnJmB1ammItD0BiJ3AP/L3eY4=;
	b=lB4Q+58ge91tYRarLhVxoRz5X+jzQpRqpDnFJxV5WKv7WPUDi/3HiP2W/nTIuhGUB43y
	 Qe11tWaW349QiWmnfvf9BtNvUGqVFlRdno0B6yeEFpW3PAv0mbLj9/km/63vQi7m7aGd3
	 5nnTIHuPaa6ECuH3G+YKXurHaHqRdoUnLsBSYEivT8Fb/PZjww1rzKsPJ3RNYjJKL9Q+y
	 R7oLw1zO/t/qJ1vOBq/JNwKztOh1DeQfVeUwZBtAfdNJHmpaMHvOt9fmEqNLHsp2pUpHO
	 +y8wUVX8Y3wbN8eFyXMFowUCYtGGVKLekqWnSoGQgfnOadWhUqQ3s1xG7SeL0XpOoEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=tPYCIFON;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A561A606A324
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:01:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A561A606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=tPYCIFON
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A98881575;
	Thu, 19 Nov 2026 10:01:06 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 396083F673;
	Thu, 19 Nov 2026 10:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795111269; bh=zU+lbf4dKpXQxDczcW78EzDZKMlSaYkD+GX/6zuF0XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tPYCIFONWpq6b25T/zhsRw2dAWUCNGj69IRMrBRaUPSHNGmYRd+1+2jy7Dlxs7FiV
	 cOcAOiIu2Yyzof7n9MYM/h+jd8hzjrNug6pDA5Bw9uPluqkU+31HbsOGBZuoTHPrbP
	 K0WPP/zVhls3xLeC/WbajljeAzw6NYZdms+b4b7Y=
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
Date: Thu, 19 Nov 2026 18:01:02 +0000
Message-ID: <av85XpdDMoYmy5X6@LeoBrasDK>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <ce87daaa-4af4-4e9c-a09a-0532b9297b0b@huawei.com>
References: <auikG0clmr19sAjh@LeoBrasDK> <afcbf19b-bd13-4afc-ab56-8bc50c793e50@huawei.com> <au30DqzWIFny1tpr@LeoBrasDK> <d81243e3-d790-4ee8-9b28-36d35591ee77@huawei.com> <avIOZTvQF-1sxs2p@LeoBrasDK> <90775cb3-84ab-4690-a252-1ac41488118f@huawei.com> <avMSw3LLDIFT3kSR@LeoBrasDK> <fee835a5-a027-4b68-b933-6f8e81987bce@huawei.com> <avXak02I6i0tLLN9@LeoBrasDK> <ce87daaa-4af4-4e9c-a09a-0532b9297b0b@huawei.com>
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

On Thu, Nov 19, 2026 at 04:51:54PM +0800, Tian Zheng wrote:
> 
> 
> On 11/12/2026 11:26 PM, Leonardo Bras wrote:
> > On Thu, Nov 12, 2026 at 09:15:02PM +0800, Tian Zheng wrote:
> > > 
> > > 
> > > On 11/10/2026 8:49 PM, Leonardo Bras wrote:
> > > > On Tue, Nov 10, 2026 at 04:54:30PM +0800, Tian Zheng wrote:
> > > > > 
> > > > > 
> > > > > On 11/10/2026 2:18 AM, Leonardo Bras wrote:
> > > > > > On Mon, Nov 09, 2026 at 12:00:52PM +0800, Tian Zheng wrote:
> > > > > > > 
> > > > > > > 
> > > > > > > On 11/6/2026 11:36 PM, Leonardo Bras wrote:
> > > > > > > > On Fri, Nov 06, 2026 at 06:36:04PM +0800, Tian Zheng wrote:
> > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > On 11/2/2026 10:54 PM, Leonardo Bras wrote:
> > > > > > > > > > On Tue, Sep 29, 2026 at 06:36:51PM +0800, Tian Zheng wrote:
> > > > > > > > > > > The dirty ring reserves room for CPU-side dirty buffers via
> > > > > > > > > > > kvm_cpu_dirty_log_size(). Report the HDBSS buffer entry count
> > > > > > > > > > > through it, so a full buffer flush always fits in the ring.
> > > > > > > > > > > 
> > > > > > > > > > > Pin the HDBSS buffer size to PAGE_SIZE when dirty-ring is enabled,
> > > > > > > > > > > via kvm_arch_dirty_ring_size_updated(): a larger buffer only
> > > > > > > > > > > shrinks the soft_limit and forces more frequent userspace drains.
> > > > > > > > > > > 
> > > > > > > > > > > Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> > > > > > > > > > > ---
> > > > > > > > > > >       arch/arm64/kvm/arm.c | 8 ++++++++
> > > > > > > > > > >       arch/arm64/kvm/mmu.c | 8 ++++++++
> > > > > > > > > > >       2 files changed, 16 insertions(+)
> > > > > > > > > > > 
> > > > > > > > > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > > > > > > > > index 9d7bdece149a..5a7046acb62e 100644
> > > > > > > > > > > --- a/arch/arm64/kvm/arm.c
> > > > > > > > > > > +++ b/arch/arm64/kvm/arm.c
> > > > > > > > > > > @@ -215,6 +215,14 @@ static int kvm_arm_default_max_vcpus(void)
> > > > > > > > > > >       	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
> > > > > > > > > > >       }
> > > > > > > > > > > 
> > > > > > > > > > > +void kvm_arch_dirty_ring_size_updated(struct kvm *kvm)
> > > > > > > > > > > +{
> > > > > > > > > > > +	if (!system_supports_hdbss())
> > > > > > > > > > > +		return;
> > > > > > > > > > > +
> > > > > > > > > > > +	kvm->arch.hdbss_buffer_size = KVM_ARM_HDBSS_DEFAULT_SIZE;
> > > > > > > > > > > +}
> > > > > > > > > > > +
> > > > > > > > > > 
> > > > > > > > > > On the same subject as a previous patch:
> > > > > > > > > > I don't think this is the best approach, on top of adding a new weak
> > > > > > > > > > function to take care.
> > > > > > > > > > 
> > > > > > > > > > Maybe during the dirty-ring allocation, on vcpu creation, we could take
> > > > > > > > > > into account the requested dirty-ring size, and just allocate the HDBSS
> > > > > > > > > > buffer taking that into account. That would make it simpler, don't you
> > > > > > > > > > agree?
> > > > > > > > > > 
> > > > > > > > > > Thanks!
> > > > > > > > > > Leo
> > > > > > > > > 
> > > > > > > > > Hi Leo,
> > > > > > > > > 
> > > > > > > > > The "set once" guard we're discussing comes from the patch that adds the
> > > > > > > > > ioctl, and it isn't really needed. We discussed this earlier [1]: we can
> > > > > > > > > just initialize hdbss_buffer_size to PAGE_SIZE at VM creation and let
> > > > > > > > > the ring reservation use it directly. **That also means
> > > > > > > > > kvm_arch_dirty_ring_size_updated() can be removed.** Thanks for your
> > > > > > > > > suggestion.
> > > > > > > > 
> > > > > > > > :)
> > > > > > > > 
> > > > > > > > > 
> > > > > > > > > As for why PAGE_SIZE is the right value in ring mode: the HDBSS buffer
> > > > > > > > > is flushed on every VM exit, so a larger buffer doesn't reduce the flush
> > > > > > > > > frequency. It only inflates the ring reservation (64 + size/
> > > > > > > > > sizeof(u64)), which shrinks the soft_limit and forces more frequent
> > > > > > > > > exits to userspace for the ring to be drained. Draining the dirty ring
> > > > > > > > > from QEMU is more expensive than draining the HDBSS buffer from the
> > > > > > > > > kernel, so the smallest buffer gives the best performance. In this mode,
> > > > > > > > > a larger buffer provides no benefit to users.
> > > > > > > > 
> > > > > > > > Humm, if properly dimensioned larger buffers would be benefitial for
> > > > > > > > memory-intensive workloads, unless they are guest_exiting for other
> > > > > > > > reasons in the meantime.
> > > > > > > > 
> > > > > > > 
> > > > > > > Agreed, and the workload I tested is on the "unless" side. The guest
> > > > > > > exits constantly for other reasons, so the larger buffer never got a
> > > > > > > chance to pay off, and only cost ring capacity.
> > > > > > > 
> > > > > > > > > 
> > > > > > > > > In my tests, I also saw performance degrade when more space is reserved.
> > > > > > > > > 
> > > > > > > > 
> > > > > > > > Humm, what kind of workloads did you test?
> > > > > > > > Did you have the chance to monitor what were the reasons for VM exiting?
> > > > > > > > 
> > > > > > > 
> > > > > > > For the workload question, it's a Redis server in the guest under redis-
> > > > > > > benchmark (SET-only, 2KB values, 1M keys, 100M requests). The traffic is
> > > > > > > network-driven, so the guest exits constantly to service requests. The
> > > > > > > HDBSS buffer only accumulates entries between two exits and is flushed
> > > > > > > on every exit, so it rarely fills regardless of size. A larger buffer
> > > > > > > only inflated the ring reservation, which shrinks the soft_limit and
> > > > > > > makes the ring-full exit and userspace drain fire more often.
> > > > > > > 
> > > > > > > > I am not saying this is mandatory for the HDBSS implementation, but the
> > > > > > > > whole idea of letting the user choose their own HDBSS buffer size is
> > > > > > > > because different workloads may benefit from different buffer sizes: if a
> > > > > > > > VM writes a lot to new memory, and exits very little for other reasons,
> > > > > > > > then a larger buffer will cause the VM to guest_exit much less often.
> > > > > > > > 
> > > > > > > > Does that make sense?
> > > > > > > > 
> > > > > > > > Thanks!
> > > > > > > > Leo
> > > > > > > 
> > > > > > > It does make sense. That's exactly the workload where a larger buffer
> > > > > > > pays off, and the next version no longer gets in its way. The two ioctls
> > > > > > > are no longer mutually exclusive.
> > > > > > > 
> > > > > > > The only coupling left is the reservation. hdbss_buffer_size starts at
> > > > > > > SZ_4K at VM creation, so a ring enabled right away reserves for the
> > > > > > > default buffer (64 + 512 entries), and the minimum ring size accepted is
> > > > > > > unchanged from v5. KVM_CAP_ARM_HDBSS_BUFFER_SIZE is the gate. When the
> > > > > > > ring is already enabled, a size is accepted only if its reservation
> > > > > > > still fits in the ring, otherwise -EINVAL. In the other order, ring-
> > > > > > > enable validation rejects a ring too small for the configured size.
> > > > > > 
> > > > > > I don't think this is needed. If using dirtyring, we don't need to allow
> > > > > > user to set hdbss size: HDBSS size should be sized according to the
> > > > > > dirty-ring dimensions, that are set by userspace before the first vcpu is
> > > > > > created.
> > > > > > 
> > > > > > 
> > > > > > > So SZ_4K is just the conservative default for guests that exit often.
> > > > > > > Anything larger, within what the ring can reserve, is up to the user.
> > > > > > > 
> > > > > > > Does this work for you?
> > > > > > 
> > > > > > I still think we should do PAGE_SIZE for dirty-bitmap. Dirty ring should do
> > > > > > based on the dirty-ring size, and maybe review the use of reserved
> > > > > > entries, or it's accounting.
> > > > > > 
> > > > > > What do you think?
> > > > > > 
> > > > > > Thanks!
> > > > > > Leo
> > > > > 
> > > > > Hi Leo,
> > > > > 
> > > > > Thanks for your review. It does make sense!
> > > > > 
> > > > > I agree that dirty-bitmap mode will keep PAGE_SIZE as the default, and
> > > > > in that mode the ioctl stays available for a larger buffer.
> > > > > 
> > > > > In ring mode we will drop the ioctl, the two remain mutually exclusive,
> > > > > and the buffer will be derived from the ring size userspace configured
> > > > > before the first vCPU is created:
> > > > > 
> > > > > ```
> > > > > hdbss_buffer = clamp_t(unsigned long,
> > > > >                          rounddown_pow_of_two(ring_size / 16),
> > > > >                          SZ_4K, KVM_ARM_HDBSS_MAX_SIZE);
> > > > > ```
> > > > > 
> > > > 
> > > > Are you allocating 1/16th of the ring size in bytes as an hdbss buffer?
> > > > That's confusing. I recommend we rather have something like:
> > > > 
> > > > ring_entries = ring_size / sizeof(struct kvm_dirty_gfn);
> > > > hdbss_entries = ring_entries / 2; // Or any number we decide to use here.
> > > > hdbss_buf_size = hdbss_entries * sizeof(hdbss_buf_entry);
> > > > 
> > > > Then we do
> > > > hdbss_buf_size = clamp_t(unsigned long,
> > > >                            rounddown_pow_of_two(hdbss_buf_size),
> > > >                            SZ_4K, KVM_ARM_HDBSS_MAX_SIZE);
> > > > 
> > > > So it's clear what is what here.
> > > > Just dividing by 16 above can be confusing to whoever is reading the code.
> > > > 
> > > > 
> > > > > A buffer entry is 8 bytes and a ring entry is 16 bytes, so:
> > > > > 
> > > > > ```
> > > > > buffer entries = buffer_size / 8
> > > > > ring entries   = ring_size / 16
> > > > > ```
> > > > 
> > > > Remember to use the sizeof instead of fixed numbers.
> > > > 
> > > > > 
> > > > > This means ring_size / 16 reserves at most one eighth of the ring
> > > > > entries for the HDBSS buffer. That keeps the usable ring above 85% while
> > > > > the buffer still grows with the configured ring size, and the result is
> > > > > independent of the kernel page size, with SZ_4K as the only minimum.
> > > > 
> > > > Yeah, remember that if you are dealing with the ringbuffer like this, an
> > > > user can request a 4k ringbuffer and we just won't be able to use hdbss, as
> > > > it means 4k/16 entries, and hdbss has the minimum of 4k/8.
> > > > 
> > > > As I mentioned, maybe this approach of reserved entries is not the right
> > > > way of dealing with it in arm64.
> > > > 
> > > > > 
> > > > > One eighth is the ratio that looks reasonable to me so far. What do you
> > > > > think?
> > > > > 
> > > > 
> > > > I see no reason why it could not be higher than that. It all depends on how
> > > > you want to deal with the full buffer in the future patchset. If hdbss
> > > > buffer is full, it has to exit and drain to the dirtyring. The guarantee
> > > > you seek with reserved entries is that all hdbss entries fit in the
> > > > dirty-ring.
> > > > 
> > > > As long as the user is required to drain entries until the dirty-ring is
> > > > not 'full' anymore, we could easily work with dirty-ring having twice as
> > > > many entries as the hdbss buffer.
> > > > 
> > > > How does it sound?
> > > > 
> > > > Thanks!
> > > > Leo
> > > 
> > > Hi Leo,
> > > 
> > > Thanks for the suggestion.
> > > 
> > > For the next version I'll still go with the reservation scheme. It's the
> > > safest approach I can think of. The guarantee I want is that a full
> > > buffer flush always fits in the ring by construction, without depending
> > > on how quickly userspace drains it.
> > 
> > Of course, it should never depend on how quickly userspace drains the ring.
> > My point is that reserved entries is not the only option that satisfies
> > that.
> > > 
> > > I'll also switch to sizeof(struct kvm_dirty_gfn) and
> > > sizeof(hdbss_buf_entry) instead of the hardcoded 16 and 8, and size the
> > > HDBSS buffer at half the ring entries as you suggested.
> > > 
> > > On the 4K ring case: HDBSS can't fit there. One option is to just not
> > > enable HDBSS in that scenario, but I'll start with returning -EINVAL for
> > > now. I'm happy to switch to the other option if you think that's better.
> > > 
> > 
> > Return -EINVAL meaning what? userspace can't set the dirty-ring to 4k? that
> > could break a lot of users.
> > 
> > Disabling HDBSS for that range could be the solution, but then we
> > would have HDBSS being used for dirty-rings above some size, which could be
> > kind of odd in the code, and possibly lead to trouble in the future.
> > 
> > That's one of the reasons I mentioned reserved entries may not be the best
> > solution for us.
> > 
> > Thanks!
> > Leo
> 
> Hi Leo,

Hi Tian,
 
> 
> I understand reserved entries aren't the only way to get that guarantee.
> I looked at the alternatives I could think of and none of them seemed
> clearly safer, so for the next version I'd like to stick with the
> reservation and revisit if something better comes up.
> 

Sure,
If you prefer, we could both bring some other ideas to the discussion, and 
rank them based on goods/bad points.

For example, I was thinking on keeping the dirty-ring and the hdbss buffer 
decoupled in size (allowing hdbss-buf to be bigger than the dirty-ring).

On draining, it could happen that the dirty-ring is full before we finish 
draining hdbss-buf. In that case, when the VMM runs VCPU_RUN again, we can 
just continue draining, and return to VMM again as DIRTY_RING_FULL, until 
it's fully drained.  

> On the 4K and 8K ring case, I agree rejecting the ring is not
> acceptable. I'll go with not enabling HDBSS instead, so every ring size
> upstream accepts keeps working. I share your concern about HDBSS being
> conditionally enabled by ring size; for now it stays confined to the
> kvm_supports_hdbss() check, and if it turns out to be a maintenance
> problem we can revisit.

Sorry, I wasn't able to understand you solution here.
(I am fine if you prefer discussing it over the next version, though)

IIUC you suggest enabling HDBSS only if the dirty-ring size is big enough 
so it fits at least 4kB/8 HDBSS entries, is that correct? 

I personally don't like the idea of fine-tunning a parameter (dirty-ring 
size in this case) is needed to be able to make use of a hardware feature, 
as it could cause weird scenarios of the users getting mixed results in 
performance until they figure that out.

But maybe I should not worry in advance.

Let me know how you want to discuss that.

Thanks!
Leo

