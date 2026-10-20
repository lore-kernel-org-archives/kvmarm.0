Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792499612;
	b=451IA60yQN5dSJQUNYahQ5V4TMxcFw34Om/u7UlDYdMblPls4OCFNuV1U9c/oiizoavc
	 bpOEQcn95v6WNxTNHMDtplM7WoeOR9KpP67znxU5EKww6khOGLfdxE7slcmRu58215K71
	 +/FK4aIlzrPghqxD3zcfcSovYN/WbsL50ravdYIgDW9jx4PTkkY7o3A2mgo5QU4qqqcta
	 CtumQDUMjizfrjQALDp1MhnX/REO0cbAwGzrF/ZsIXGVUpMPZ5CxMq5622mQ/x3vo+u1N
	 GblqBn80xbblVe6+a0azQft4LpOwVmGOYZkU0TQ95HgeA7cGMgb2o+qDZYQ32URM+rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792499612;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=GPLC8o5SopY2/JwIMyGwlvxapT2M/nYAW+f6CZhs/0U=;
	b=AtwmD4vYiMAzm0+X37Rtp9i4+FmnMUBs19HtAEmmeYnto8ktSh6sz6mOHMXvrvWoZlsF
	 n5RnFRd9iwPsECLJ/h9A8RJS47VT8J+G12GKIRh5q1f/tvB5hfe8h1GYoLZiQXVcfMRKR
	 GgpDQ4MD4gLaDDiuottYtmMCx1QkoPwhZkbpM/iYWoD2/yuwjqyuV1neRYflMj8/ZHs9/
	 82CdKVrL3GHdW0lw69kWwICZ2PDMi1XHYEX7xfbr07r7QDb5+VorL6dzjDi1Bk6ryIesP
	 n5Bl4CiGBZsvPUo+HKGtVHbHrGi2rGdcTvok9HzCfAYUkv8NepkEwVQzTZ8j0A+L4UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=AoSe0bwA;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA73606A319
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 12:33:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DAA73606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=AoSe0bwA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792499610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GPLC8o5SopY2/JwIMyGwlvxapT2M/nYAW+f6CZhs/0U=;
	b=AoSe0bwA+Qi9g3ulJedO3GG3dW9MHVFj4k4/qgaU89VYkPmFSv2TonOoqg1CdDB3Kj2+ee
	ArR9xMopRAyG4TFsRwKoKw0ckvUgdrerVGHqxdYpCU/QV/xeyGNr42gh2QsTIHuRsotHr+
	ZZjJI5cbbEqDUNxiJbc7rt6p2hvwATg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-kpmyxj4FPrKzeJL54lOmpA-1; Tue, 20 Oct 2026 08:33:29 -0400
X-MC-Unique: kpmyxj4FPrKzeJL54lOmpA-1
X-Mimecast-MFC-AGG-ID: kpmyxj4FPrKzeJL54lOmpA_1792499608
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48e1ad3cb66so898903f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 05:33:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792499608; x=1793104408;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GPLC8o5SopY2/JwIMyGwlvxapT2M/nYAW+f6CZhs/0U=;
        b=sbeyT2ln0kdQj7MH1Fu8w2aGZmtbUABROSB7Ix03pDZ3T4bDn3sVV3/d5Pgn/Tiv2c
         B34+B7LNUEoF+QzdhkJmfDBV9oL6+aFCgcMjZmMN2hkQ5hXIj7JeVmfSvOYHNoxHqE5M
         7a8FGfb7Am+FuXOOTIFqmCMZsUbWPX+KYKpIDzNOcDdc4uPyWddTXLImIl8RhhKwxlu7
         3PNVpaBIqdAqvljSJXNDtU+OLK3+r7xQ+RBx1M4DTQJtCMsN6ILUvVS4zcYEvf+AK7dZ
         avjXpFcDrRYTldpFpx6Oufqq/s32KeTtTKLiXx8BFSxXOLBTJCw4mOOxCMcTIA/fca1L
         z+qQ==
X-Gm-Message-State: AFq9FYJytVaHDPDZZ/SUbIz8O0fIzJ6nus9FDt0DinFn7pgmJWZMHYBC
	8pJotWxwcm6zJrOuw/jBssPBIPP5X0E/pXFvR4P65BjTEwbMUnQYWonyqoQ3zntSmEoGeANzt4+
	86JxHOrS+dSaefir2v+p4NAH8Ua+E4XqntwGsC4/tPHVA4KuEqACqJwZSB2TGotBigA==
X-Gm-Gg: AYBFou3W0vG1cOs8HFYSHpVTv5AAxprIicBsL009sunyKC8+yzWhfa1Y2/J9+crDlA/
	+rg/KXiwXHdliCXiZIkF8GKAXRIfy43aVo6TpAutZbcm17SxpMG0WYVjznQ5OXzL2MY6aqWj5KA
	mr4cl/HblQCSHHxOKIBUjFcX4tBgeF5f22uKnKM9J7srM2DaS5Ahu80WUk1irc/KnBJYwr8wEVx
	ZiWiQ9ZsiE9zu/1O42TrKX4/2oQ+a/ixYc0ZxRkWHDkNYVKsOHzJUG67nn//C+mi/P0yMvOwZHo
	9Py4AoCvgauow6Hn3+z8fHvLdNR0b6j3caYZbyIqhCUov3YnXweZ2w1nfnUI
X-Received: by 2002:a05:6000:2990:10b0:486:f4ae:72a2 with SMTP id ffacd0b85a97d-48e07b9201emr16604619f8f.1.1792499607771;
        Tue, 20 Oct 2026 05:33:27 -0700 (PDT)
X-Received: by 2002:a05:6000:2990:10b0:486:f4ae:72a2 with SMTP id ffacd0b85a97d-48e07b9201emr16604579f8f.1.1792499607364;
        Tue, 20 Oct 2026 05:33:27 -0700 (PDT)
Received: from x1 ([151.41.153.165])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e1d818d61sm5728198f8f.31.2026.10.20.05.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 05:33:26 -0700 (PDT)
Date: Tue, 20 Oct 2026 14:33:24 +0200
From: Gustavo Romero <gromero@redhat.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Decouple computation of the GICv5 trap
 registers from FEAT_FGT
Message-ID: <txi37sltlqtxakyxpk2aim2hrazoa57n3sses6wlc2g3cpwi7k@dm5lre2smxrh>
References: <20261020104138.2641586-1-gromero@redhat.com>
 <sashiko-outbox-178860@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <sashiko-outbox-178860@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zQxnsCjGMyzMEuYEh7exM6J1NZjPI0o3i6xJWzygJ90_1792499608
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi robot,

On Tue, Oct 20, 2026 at 10:53:22AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] KVM: arm64: populate_nv_trap_config() skips GICv5 FGTs when FEAT_FGT is absent
> --
> 
> commit 78d2daa299df3d77e7dfa794f19cd0a1eee7919c
> Author: Gustavo Romero <gromero@redhat.com>
> 
> KVM: arm64: Decouple computation of the GICv5 trap registers from FEAT_FGT
> 
> This commit moves the computation of ICH_HFGRTR_EL2, ICH_HFGWTR_EL2, and
> ICH_HFGITR_EL2 in kvm_vcpu_load_fgt() ahead of the ARM64_HAS_FGT check so
> that GICv5 trap register values are computed whenever ARM64_HAS_GICV5_CPUIF
> is present, even if the CPU lacks FEAT_FGT.
> 
> > diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> > index e93919cadf860..0833453efe4bb 100644
> > --- a/arch/arm64/kvm/config.c
> > +++ b/arch/arm64/kvm/config.c
> > @@ -1744,6 +1744,12 @@ static void __compute_ich_hfgwtr(struct kvm_vcpu *vcpu)
> >  
> >  void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
> >  {
> > +	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
> > +		__compute_ich_hfgrtr(vcpu);
> > +		__compute_ich_hfgwtr(vcpu);
> > +		__compute_fgt(vcpu, ICH_HFGITR_EL2);
> > +	}
> > +
> >  	if (!cpus_have_final_cap(ARM64_HAS_FGT))
> >  		return;
> 
> [Severity: High]
> Does populate_nv_trap_config() in arch/arm64/kvm/emulate-nested.c also need
> to be updated to store the ICH_HFGRTR_GROUP and ICH_HFGITR_GROUP entries into
> sr_forward_xa when ARM64_HAS_GICV5_CPUIF is present but ARM64_HAS_FGT is
> absent?

I guess you're right but it was already addressed by Fuad's patch:

https://lore.kernel.org/all/20260929090031.3829185-2-fuad.tabba@linux.dev/

that is already in the mainline:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4bdd2b3a708c1feb701cb8b62feb8ad2fd77bb07

Maybe you're looking at some branch that doesn't have this fix?


Cheers,
Gustavo
 
> Currently, populate_nv_trap_config() skips storing any entry into
> sr_forward_xa when ARM64_HAS_FGT is not supported:
> 
> arch/arm64/kvm/emulate-nested.c:populate_nv_trap_config() {
> 	...
> 		for_each_encoding_in(enc, fgt->encoding, fgt->end) {
> 			...
> 			if (!cpus_have_final_cap(ARM64_HAS_FGT))
> 				continue;
> 
> 			prev = xa_store(&sr_forward_xa, enc,
> 					xa_mk_value(tc.val), GFP_KERNEL);
> 			...
> 		}
> }
> 
> Because of that, on a system with ARM64_HAS_GICV5_CPUIF and !ARM64_HAS_FGT,
> the GICv5 entries in sr_forward_xa are left with tc.fgt == __NO_FGT_GROUP__
> (populated only with tc.sri by populate_sysreg_config() for registers in
> sys_reg_descs[], or left at 0 for all other GICv5 registers and instructions).
> 
> When a guest running without FEAT_GCIE (for example, a GICv3 guest in
> compatibility mode, or a VM where ID_AA64PFR2_EL1.GCIE was cleared) executes
> a GICv5 system register or instruction access, kvm_vcpu_load_fgt() has
> cleared the trap bits in ICH_HFGRTR_EL2, ICH_HFGWTR_EL2, and ICH_HFGITR_EL2
> from kvm->arch.fgu[], so the access traps to kvm_handle_sys_reg() ->
> triage_sysreg_trap():
> 
> arch/arm64/kvm/emulate-nested.c:triage_sysreg_trap() {
> 	...
> 	if (tc.fgt != __NO_FGT_GROUP__ &&
> 	    (vcpu->kvm->arch.fgu[tc.fgt] & BIT(tc.bit))) {
> 		kvm_inject_undefined(vcpu);
> 		return true;
> 	}
> 	...
> }
> 
> With tc.fgt == __NO_FGT_GROUP__, this FGU check is bypassed instead of
> injecting an UNDEF:
> 
> - A guest read of SYS_ICC_PPI_ENABLER0_EL1 or SYS_ICC_PPI_ENABLER1_EL1
>   dispatches to access_gicv5_ppi_enabler() in arch/arm64/kvm/sys_regs.c with
>   !p->is_write, triggering WARN_ON_ONCE(!p->is_write).
> 
> - A guest write to SYS_ICC_PPI_ENABLER0_EL1 dispatches to
>   access_gicv5_ppi_enabler() and writes to
>   vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_enabler, which shares a union with
>   vgic_v3 in struct vgic_cpu.
> 
> - Guest reads of SYS_ICC_IDR0_EL1 or SYS_ICC_IAFFIDR_EL1 execute
>   access_gicv5_idr0() or access_gicv5_iaffid() instead of injecting UNDEF.
> 
> - Guest accesses to other GICv5 registers or instructions fall through to the
>   local label with !tc.sri and log "Unsupported guest access at:" on the host
>   before injecting UNDEF.
> 
> >  
> > @@ -1761,10 +1767,4 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
> >  		__compute_fgt(vcpu, HDFGRTR2_EL2);
> >  		__compute_fgt(vcpu, HDFGWTR2_EL2);
> >  	}
> > -
> > -	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
> > -		__compute_ich_hfgrtr(vcpu);
> > -		__compute_ich_hfgwtr(vcpu);
> > -		__compute_fgt(vcpu, ICH_HFGITR_EL2);
> > -	}
> >  }
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261020104138.2641586-1-gromero@redhat.com?part=1
> 

