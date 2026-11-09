Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794247643;
	b=mPgxfAUUQ0UDzcUTNlSeG1V8KoVPLCQLs1SHdpBjaV7eqcDzlA9pdQLaggJVnEzL39ty
	 B/yqrCpPQ7HtHgy/LjW3FHF4hgtj7wYtYG38ReQOokqOoP3wR/SCvrUOGvik3EemTKaSt
	 aPRn7E5DTuzZld382ftsfm/sVPASSFj9adAe+LVxXxtHrphOwpmgCbDq3CGo8TjZStrKy
	 b48JyCMcb0o7SswuLwImmlJzlPdojXYudbmKbtaWa7shaQNjCthW07bs1c5i+lLGR9Cte
	 mXBhjSnXzJUdPnQX8KkTVTeHuVGHsWvrSorVNwVEeZ1RD8wLrAg7bqiSWNJJy5+TR5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794247643;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=9SX+jH/mGjt4SuPHBiqFjWciDYJaR9hX+EeARBcc/oU=;
	b=i6ulLB15XiZdPczjHvKystO4Qh9eXof0AFfBfvF5Up1incCnsl4wNus7ARESOlWHvTlL
	 oigQtOR+1HA96uqhW3iJNX3UPn49kOkxCDeaU6/yB9xj8Os9k8kh1Otu1O3I2kjQk01B6
	 ImCbAWh8M9nmmVOcNbWs6aqlWShhkhv+E8U8Ks23t7md4ggyV+WJjTgTelm/5y/rsw1un
	 gCTa3wB7RCKnT637DoEb8FPxiYRyaZFn0rmx+bLyTGieXEBmVV8MI6zakP3pkojhIhFjZ
	 Enibk1FlmxExSQyMtG53j6C3qsOMnAjZdHvKQEHfYIv/wt5yygRqbh1QHseXnnPjKDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=qP+j2+Ou;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65EEC606A32A;
	Mon,  9 Nov 2026 18:07:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65EEC606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=qP+j2+Ou
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A57AC1476;
	Mon,  9 Nov 2026 10:07:18 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F0173F85F;
	Mon,  9 Nov 2026 10:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794247641; bh=sg6g4W54QBZxZYKEgqRqF44StZN9salD9l+AhfoCf24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qP+j2+OuqLKE4Lm1XPuvDQfifQzUJQrjIkKWp7O+3YIWfTLRRKALZBcqMBJBQ4pVj
	 UnRfSf2OfKmjhmX5moUFLtpmbRdwBu9Jh1YNNCvkMCNM20pc19zX+JUhymaFR6y48Q
	 ODg7QF+BE2r+iUQBNRqwepfxrL0MrxFWU9EBIJ9Y=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	sashiko-reviews@lists.linux.dev,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	liuyonglong <liuyonglong@huawei.com>
Subject: Re: [PATCH v5 11/15] KVM: arm64: Reserve dirty ring space for the HDBSS buffer
Date: Mon,  9 Nov 2026 18:07:17 +0000
Message-ID: <avIL1UFsFmQFXwew@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <494abfd0-b19b-4ef3-a035-d21626828a6a@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com> <20260929103655.85107-12-zhengtian10@huawei.com> <20260929110035.71FB41F000FF@smtp.kernel.org> <494abfd0-b19b-4ef3-a035-d21626828a6a@huawei.com>
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

On Mon, Nov 09, 2026 at 06:03:03PM +0800, Tian Zheng wrote:
> 
> 
> On 9/29/2026 7:00 PM, sashiko-bot@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> > - [High] arm64: kvm: UAPI breakage for dirty ring size on 64KB page systems
> > --
> > 
> > commit 38dde0ab2f10c37402c620c7b1328624808205ad
> > Author: Tian Zheng <zhengtian10@huawei.com>
> > 
> > KVM: arm64: Reserve dirty ring space for the HDBSS buffer
> > 
> > This commit reserves space in the dirty ring for CPU-side dirty buffers by
> > implementing kvm_cpu_dirty_log_size(). It also pins the HDBSS buffer size to
> > PAGE_SIZE when the dirty ring is enabled.
> > 
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > index 7bf82d65041c8..c1e09ba98d48a 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > [ ... ]
> > > @@ -2841,3 +2841,11 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
> > >   	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
> > >   }
> > > +
> > > +int kvm_cpu_dirty_log_size(struct kvm *kvm)
> > > +{
> > > +	if (!system_supports_hdbss())
> > > +		return 0;
> > > +
> > > +	return kvm_hdbss_buffer_size(kvm) / sizeof(u64);
> > > +}
> > 
> > [Severity: High]
> > Does this calculation break the UAPI for standard dirty ring size requests on
> > 64KB page systems?
> > 
> > Since KVM_ARM_HDBSS_DEFAULT_SIZE is tied to PAGE_SIZE, this calculation scales
> > with the system page size. On a 64KB page system, kvm_hdbss_buffer_size() yields
> > 65536 bytes, returning 8192 reserved entries (65536 / 8).
> > 
> > When a userspace process requests a standard dirty ring size of 65536 bytes
> > (64KB) via KVM_ENABLE_CAP for KVM_CAP_DIRTY_LOG_RING, it seems the ioctl will
> > now fail:
> > 
> > virt/kvm/kvm_main.c:kvm_vm_ioctl_enable_cap() {
> >      ...
> > 	if (size < kvm_dirty_ring_get_rsvd_entries(kvm) *
> > 	    sizeof(struct kvm_dirty_gfn) || size < PAGE_SIZE)
> > 		return -EINVAL;
> >      ...
> > }
> > 
> > Because (8192 + 64) * 16 = 132096 bytes is greater than the requested 65536
> > bytes, the ioctl rejects previously valid userspace configurations with -EINVAL,
> > which would cause QEMU and other VMMs to fail to start VMs.
> > 
> > Could this buffer size be decoupled from PAGE_SIZE to avoid the entry inflation
> > and ABI breakage on 64KB page systems?
> > 
> 
> You were right, this is a real UAPI break on 64KB-page kernels. The
> PAGE_SIZE default made the ring reservation scale with the kernel page
> size, so a standard 64KB ring request got rejected there.
> 
> Leo, the PAGE_SIZE default goes back to your suggestion in the v4
> discussion at [1]:
> 
> > That means 512 entries in 4kB pagesize, an 8K entries in 64kB
> pagesize.
> 
> > I mean, yes, maybe we could allocate a 64k page, and set SZ=4K in
> HDBSSBR, but that would be a waste of memory, right?
> 
> If we keep PAGE_SIZE, the ring ABI stays broken on larger-page kernels,
> since the reservation keeps scaling with the page size. With SZ_4K there
> is still some breakage, the smallest ring sizes (4KB and 8KB), but that
> is the smallest scope we can get, because 4KB is the smallest buffer the
> hardware can encode. Defaulting to SZ_4K also brings our ring
> requirements in line with x86, where PML reserves the same fixed 576
> entries.
> 
> Do you think we should default to SZ_4K and accept the page waste you
> pointed out, or keep PAGE_SIZE?
> 

Maybe we should rethink the way of handling this, and maybe reserved 
entries is not the way out. 

(It was for x86, but it's a very different architecture, as I mentioned 
before)

Another approach could be to those reserved pages to not be counted in the 
ring size limit, but that could become really messy.

Thanks!
Leo
