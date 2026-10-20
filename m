Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792505014;
	b=L4bEqnBIUU9FJgKBMpx1vD1CwkXUpBqcKH3H4qkNXjISAtez+6euu2icHrWLsnQYFx8J
	 TU8OKgcbgr/FgbTgVATrSAVPlP0QUKgKr1kLGAGk7fjrSLli71OW9E60IR7SAItD23p0h
	 otyjIkO1kxZTojGY3vM3ENsuNzwjhH12EUto+mY83FuUjI4V/40u0ffqxiU1b0FgnReRl
	 s7FrOWiNTVHmlo3mfs4V7leiQaxYPimPaoiAxJ9gDoj1NKllqRB/a3PCRjIelcwq0Uj7q
	 QPmhHtyphTbN3raqkhQDAeX2N2khpnyjXRZRPNpfkRwH4UF2VWyg39LHBiazMKust5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792505014;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Type:Content-Disposition;
	bh=smDqeeLqssr6n3tx11H7D54ow1DPjOC5hRE7K2Aj3SA=;
	b=Y5QAAbILOqD9m+W7JVv7cO9xjusc03MTSphJSEFRZjKPLyrIlmAHlpjYjjUMXxOHBVQg
	 6mNBXW0Nc/QtQBbpXOq/t3a/2I+Mjr03OcB1WdyfS2IBY1yGQ4gUFnbE5O6XRVHaz1o76
	 O3U7j8dALN69p1fLz0oab0BIRHtyxSip/+lupp/3iLDm9VEu3Ii9w++BIXTQB3//afSv0
	 BkfROJh4PT3xaitu33YhwA3fsRmmCuhuGGhVjP6hPxwxLJfWRsEOcm7x4N/vNCg8VZIvO
	 rnn1G91AiXAfjqD35r3IJPotzJkUoaPwP+OkRHv0DkNTrS3Irb/R5yVSxcv6p68+XDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LHTw9lei;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F70606A31C
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 14:03:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99F70606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LHTw9lei
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792505012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=smDqeeLqssr6n3tx11H7D54ow1DPjOC5hRE7K2Aj3SA=;
	b=LHTw9leiP2oDilkFWnUJtSEIgeriMdr6ittMPoW4cXmEtfchtTRMCe4t5aRf70C6gf/Qyq
	kiGsRHEQLVN4oIqGXNlnFcyXX8Q/R6lFKMAan6cMA+F5IsWwovwNLhkkrLnbYVEiZbutpq
	Zp6j/s+fmQ4Mxbol+aukptzFc5721zU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-466-RwTgTpOiMP2s0lSUNy644Q-1; Tue, 20 Oct 2026 14:03:30 +0000
X-MC-Unique: RwTgTpOiMP2s0lSUNy644Q-1
X-Mimecast-MFC-AGG-ID: RwTgTpOiMP2s0lSUNy644Q_1792505010
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48e17d30a79so1462407f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 07:03:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792505009; x=1793109809;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=smDqeeLqssr6n3tx11H7D54ow1DPjOC5hRE7K2Aj3SA=;
        b=2ywpazO84EquoSPcaSZ7yS+Pi2wrdbCTurOYmp9Rgbw7mWt66Z4/LScgTj1mJ8aVO+
         j6s7wXwobPF1cUv8qNov+YHNEG0Q6zZoR1zAn0QNJjL+98CeGj3n+q3XfSuMgGcRpQbY
         IycemeZW0vmOpR+iO9PqZkLlHIUninFhM64ahb8gTtqnZRzocmdBiWt4O+n7StekIYP3
         VZrmjtwwuMAhG9nDlgEkxKQVODDnqQfh1ivFeGjcD9nc4naAA5oyuGJx9hoK84/Ec57I
         xFeB25g2TjTeK01obcSl1fqpF9QGA/GTkfCyAXZbSA0dbV2zGcd1lEFcgaE7S23hX3lL
         HgMw==
X-Gm-Message-State: AFq9FYKiQU2ZLPnvWXGDfcQEEEbBkrJr1oD66cme0s8P2EYODGZlhq4J
	hrEHHZhBXn41kyvdfdWOqorjVzzxi4AgwlCyUKr2OjkGXriUGNlxj9PYkyjvgK5BOlkeP1VgjbS
	WnvfRHaOtwMj5ckghotbZJiQTNK1CwwrPXMoc75CVAy/hTJctwIsKS3W64Q==
X-Gm-Gg: AYBFou3xC/jIrA7HcjfF2N83o+UGRmF2xehwC4f6mlNe3jRHnQVGr5+4AfJC5GY/Pv/
	DmaZ2uUqcMFuv5D3ZlxNWYH11fbTjs/cjkbMbCprI3yl8fvQaNdhDGFP1yqN9n+wWoYmx9ZVfAZ
	CR7b4WZ6TUKlJ/jzbEenrdlOBa6NjMZi5aF6mWas8nHoR5cBhAmSTQRyQ5E/UujWvPqGsqvXZYl
	pGdG/e6jayn+RNfvci2FdLXszjq0W6LVna2bK5/EJXWIO3mgQED4AX3W993q6/PWU2l16WiLJ2H
	rNhzJA541BdnbWnjk1Igqx9r/Dtkulo5RjPD6soGQbeeuXL8VrOZ5wDXD9nX
X-Received: by 2002:a05:6000:4287:b0:48e:f07:160e with SMTP id ffacd0b85a97d-48e0f071653mr16722264f8f.38.1792505009399;
        Tue, 20 Oct 2026 07:03:29 -0700 (PDT)
X-Received: by 2002:a05:6000:4287:b0:48e:f07:160e with SMTP id ffacd0b85a97d-48e0f071653mr16722223f8f.38.1792505009020;
        Tue, 20 Oct 2026 07:03:29 -0700 (PDT)
Received: from x1 ([151.41.153.165])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e1d8178dbsm6700875f8f.21.2026.10.20.07.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 07:03:27 -0700 (PDT)
Date: Tue, 20 Oct 2026 16:03:24 +0200
From: Gustavo Romero <gromero@redhat.com>
To: Sascha Bischoff <sascha.bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, fuad.tabba@linux.dev, maz@kernel.org, 
	oupton@kernel.org, eric.auger@redhat.com, seott@redhat.com
Subject: Re: [PATCH] KVM: arm64: Decouple computation of the GICv5 trap
 registers from FEAT_FGT
Message-ID: <k5dfmpduel5iejhmmk4htypmuxsoxawwsuetyivm3r6adkx2d7@wn52vb7qzmos>
References: <20261020104138.2641586-1-gromero@redhat.com>
 <36a94626-f760-4eb6-acf2-13c1ad128391@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <36a94626-f760-4eb6-acf2-13c1ad128391@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wxAEICKFnd5witYhOf3tpUqJv0-IMx3uk7xiXXrpSQ4_1792505010
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Sascha,

On Tue, Oct 20, 2026 at 01:45:43PM +0100, Sascha Bischoff wrote:
> Hi Gustavo,
> 
> On 20/10/2026 11:41, Gustavo Romero wrote:
> > Currently, kvm_vcpu_load_fgt() returns early when the CPU lacks FEAT_FGT,
> > so the per-vCPU ICH_HFGRTR_EL2, ICH_HFGWTR_EL2 and ICH_HFGITR_EL2 values
> > are never computed and stay 0, meaning any access to several GICv5
> > registers will trap, like an access to ICC_PPI_PRIORITYR0_EL1.
> 
> This is never a valid configuration for GICv5 on a system that has EL2,
> i.e., one that supports KVM.
> 
> * FEAT_GCIE (GICv5) is optional from v9.3.
> * FEAT_FGT is mandatory from v8.6, if an implementation has EL2 or EL3.
> * v9.1 must be v8.6 compliant.
> * If we are running KVM, we must have EL2.
> 
> There's no way to legally have GICv5 without also having support for
> FEAT_FGT.
> 
> FWIW, Marc caught me making the same mistake:
> 
> https://lore.kernel.org/all/86o6o3oehl.wl-maz@kernel.org/

oh, so you've been there already :)

Thanks a lot for pointing me to that discussion.


> > 
> > On the other hand, __activate_traps_ich_hfgxtr() is gated only on the
> > GICv5 CPU interface and writes them on every guest entry, which is
> > correct.
> > 
> > Returning early when the CPU lacks FEAT_FGT and leaving the GICv5 traps
> > enabled can lead to a KVM "Unsupported guest access at" error when a
> > GICv5 register access by the guest traps to KVM, because the register
> > has no emulation handler.
> > 
> > A real machine with no FEAT_FGT and with GICv5 support enabled is
> > unlikely to exist
> 
> Given the above, very unlikely. I hope... :)
> 
> > , but such a setup can happen on some simulators, like
> > FVP with the following flags:
> > 
> > -C cluster0.has_arm_v8-5=1
> > -C bp.is_gicv5_used=1
> 
> Even if the simulator allows it, it isn't a valid configuration. You want
> v9.3 or greater here. Moreover, we shouldn't be writing code to support
> architecturally invalid configurations.

Yeah, I agree.

Now I also see the code has the assumption that FEAT_GCIE always imply FEAT_FGT,
but FEAT_FGT does not imply FEAT_GCIE, so indeed these two features are, in that
sense, not totally independent.

BTW, the output in the thread you pointed out:

	(FEAT_GCIE ==> v9Ap3)
	(FEAT_FGT ==> v8Ap5)
	(v9Ap3 ==> (v9Ap2 && v8Ap8))

seems some form of processed AARCHMRS. Are you folks using any script to digest
it?


Cheers,
Gustavo

> Thanks,
> Sascha
> 
> > 
> > Hence, because the ICH trap registers are part of FEAT_GCIE, not part of
> > FEAT_FGT, compute them before the FGT check, making this computation
> > independent of FEAT_FGT.
> > 
> > Fixes: 9d6d9514c08f ("KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs")
> > Signed-off-by: Gustavo Romero <gromero@redhat.com>
> > ---
> >   arch/arm64/kvm/config.c | 12 ++++++------
> >   1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> > index 1053676551af..8a526704af59 100644
> > --- a/arch/arm64/kvm/config.c
> > +++ b/arch/arm64/kvm/config.c
> > @@ -1744,6 +1744,12 @@ static void __compute_ich_hfgwtr(struct kvm_vcpu *vcpu)
> >   void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
> >   {
> > +	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
> > +		__compute_ich_hfgrtr(vcpu);
> > +		__compute_ich_hfgwtr(vcpu);
> > +		__compute_fgt(vcpu, ICH_HFGITR_EL2);
> > +	}
> > +
> >   	if (!cpus_have_final_cap(ARM64_HAS_FGT))
> >   		return;
> > @@ -1761,10 +1767,4 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
> >   		__compute_fgt(vcpu, HDFGRTR2_EL2);
> >   		__compute_fgt(vcpu, HDFGWTR2_EL2);
> >   	}
> > -
> > -	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
> > -		__compute_ich_hfgrtr(vcpu);
> > -		__compute_ich_hfgwtr(vcpu);
> > -		__compute_fgt(vcpu, ICH_HFGITR_EL2);
> > -	}
> >   }
> 

