Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6D7E4A2623
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 14:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790000939; cv=none; b=DoxleWxnx3CwpadnJqgv1qUr2x9M+CaKXS6a77biiLlXHv+4JixX3J+CNgjaczLxZPLDMZ6F2Um449xNlnrt3DRQqdqZaHCj7jP8kls67Uh7p72pQ5Kv/E7+PXHrYqbhsdcSCAwBkc+wF461eNt03Tf5n4YLK04fQF5eeRFF0UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790000939; c=relaxed/simple;
	bh=GdCBBFERQ2MnZAE4vUIvESlZ/KGfgi3JMauYWLFutKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=Hpx6RrCo2v24GTz38P23gqS3AU7Tck/m9sFHLUUkBiS929F6kwEpVAfyQrjobpYllRWXL537AH7XvwG/AeAz4KxRC30EySqj7Hi+O1tWXGHAFclvDxzMwjYT6dU252vXnjhtmQydH8sQ1Qurm3j7+1kSOTfGKZrOcKySIpajaSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=vT9ISrEB; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="vT9ISrEB"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9E3419F0;
	Mon, 21 Sep 2026 07:28:53 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8164F3F86C;
	Mon, 21 Sep 2026 07:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790000937; bh=GdCBBFERQ2MnZAE4vUIvESlZ/KGfgi3JMauYWLFutKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vT9ISrEB7+Z18zVsimq7PdDh0N9QjdkuO2kUdjV2nTxj6pxb2tT8duNAb44eMm0Tb
	 PQla5NKFcP4jbzx4/d/tTgWrWui+PHzIhwZvgdT3PBoD+1bYzU8IzQyGHa5jvxteUN
	 7YZqBzg6zMSI01xinyU83P9XziedpXrJFfiZtPhQ=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/5] KVM: arm64: Enable HAFDBS for guests not on migration
Date: Mon, 21 Sep 2026 15:28:54 +0100
Message-ID: <arE_Jh4UHiUdjrSi@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <497c6239-a75f-4087-83c8-efface3fe3d7@huawei.com>
References: <20260901171558.2674031-1-leo.bras@arm.com> <20260901171558.2674031-6-leo.bras@arm.com> <497c6239-a75f-4087-83c8-efface3fe3d7@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Sep 18, 2026 at 07:58:43PM +0800, Tian Zheng wrote:
> 
> 
> On 9/2/2026 1:15 AM, Leonardo Bras wrote:
> > @@ -2570,53 +2571,76 @@ int __init kvm_mmu_init(u32 hyp_va_bits)
> >   out_destroy_pgtable:
> >   	kvm_pgtable_hyp_destroy(hyp_pgtable);
> >   out_free_pgtable:
> >   	kfree(hyp_pgtable);
> >   	hyp_pgtable = NULL;
> >   out:
> >   	return err;
> >   }
> > +static void kvm_set_hafdbs(struct kvm *kvm, bool set)
> > +{
> > +	/* Check if no action required */
> > +	if (!!(kvm->arch.mmu.vtcr & VTCR_EL2_HD) == set)
> > +		return;
> > +
> > +	if (set)
> > +		kvm->arch.mmu.vtcr |= VTCR_EL2_HD;
> > +	else
> > +		kvm->arch.mmu.vtcr &= ~VTCR_EL2_HD;
> > +
> > +	kvm_make_all_cpus_request(kvm, KVM_REQ_RELOAD_STAGE2);
> > +}
> > +
> 
> Hi Leo,
> 
> HD alone is architecturally a no-op. According to the Arm spec, the
> VTCR_EL2.HD field description reads: "When the Effective value of
> VTCR_EL2.HA is 0, this field behaves as 0 for all purposes other than a
> direct read of the value of this bit." So patch 5 as it stands never
> actually enables stage-2 dirty management.

Oh, right, I missed that. :/

For the above to work it would need to have the HA bit:

+	if (set)
+		kvm->arch.mmu.vtcr |= VTCR_EL2_HA | VTCR_EL2_HD;
+	else
+		kvm->arch.mmu.vtcr &= ~(VTCR_EL2_HA |VTCR_EL2_HD);

> 
> In the combined series, I'm planning to replace both kvm_set_hafdbs()
> and our earlier enable/disable hooks with a single derived mode:
> 
> ```
> /*
>  *   logging && HDBSS-capable  ->  HDBSS  (HD|HA|HDBSS)
>  *   logging, no HDBSS         ->  off
>  *   !logging, HAFDBS-capable  ->  HAFDBS (HD|HA)
>  */

Yes, seems correct, if the performance numbers can show patch 5 provides
performance improvements.

> void kvm_arch_update_hw_dirty_mode(struct kvm *kvm)
> {
> 	bool logging = atomic_read(&kvm->nr_memslots_dirty_logging) != 0;
> 	unsigned long target;
> 
> 	if (logging && kvm_supports_hdbss(kvm))
> 		target = VTCR_EL2_HD | VTCR_EL2_HA | VTCR_EL2_HDBSS;
> 	else if (logging || !kvm_supports_hafdbs(kvm))
> 		target = 0;
> 	else
> 		target = VTCR_EL2_HD | VTCR_EL2_HA;
> 	...
> }
> ```

Humm, do we actually need the atomic_read being ran when we are enabling 
dirty_logging? Maybe we can restrain it only to the disabling part.

> 
> HA is always set alongside HD by construction, so the no-op issue goes
> away.

Right.

> 
> I'll fold this into the HDBSS v5 series when I send it out. Let me know
> if you'd rather keep it in your v2 instead.
> 

Feel free to merge your part on top of that, I will work on collecting the 
numbers, though.

Thanks!
Leo
