Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CB5471437
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 10:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786097718; cv=none; b=Fl993hzzWzT0wJYtyzJj/EXbOju0uqaOGbcLHhkdgksxV5B8DgUX5gCtkk9XmcAIfQaVpthZ0VihCecTBpog+Fc6p+VwLlPniUlTtOhbukw3nxDzXpmiAKmDZNOXOIfTrgtOelamKUgQ+o7HJP/Ob7MCPBfyWePhMOnV4UjjHG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786097718; c=relaxed/simple;
	bh=taOCHLaL5kIVt15L3LDoPk7UAuBfpQckoZOUJLe2l6Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=imjLCqaRNkDgtrNE6CdQM+P6miSGqA1Au6sMZ05q1mp8wxZR8GkKOBqAHzDeANdUFagu1yChQP/1m/aqD5HOFqAEA4WS3Cxs7MIT69wxflccncPoN3NAcFGsPRMshFnHx97iVWcrNZuF9uelaEn7kgj+1Cfyx5ewF7oupJDQtfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bfRQ+PLU; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bfRQ+PLU"
X-Forwarded-Encrypted: i=1; AHgh+Rri31wzvCn5lA0iyBx9SFplnTb90+MygFIY5esTdZwUzNQAXglaYfmwdR6PdwpMOWl26usQTrI=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786097711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uDjRXP2df5cgNvzCtbBydFsofHWCi/T7LTXM/Z135R4=;
	b=bfRQ+PLU5AQnIWB1kbPRVY2wp3zjJGXdpfw55bdswx7t0kChn5LaQZ7ISceJZrEj1Gqg+Z
	eyJH77JadmihVBUosJ56foNleqWZcVjaoIa/N5lbtQGH38nf77QoqVPzWQ0BsKo8ufcHef
	LLW7EHXJWEhpStcyYJCifTeh6TlWqnU=
X-Gm-Message-State: AOJu0YzyHmSRU7vr6KMHyg3mTIOIwtbHW6jR1kVW8xaPYFjNKk3foKkZ
	BV5r4pOjRL7wGnW6yhILHQIh8UsfJZeeJZe4D2NdlBF05V/M3/JYqdzkxLjIK3HngNZ2BcyQR1g
	c6IFQfdlSAUffRl7gx57Pz493lHZNUA9xPEdNmnmj
X-Received: by 2002:a05:622a:11c1:b0:51c:ca9:3d15 with SMTP id
 d75a77b69052e-52d109753d2mr13832331cf.12.1786097697194; Fri, 07 Aug 2026
 03:14:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260806100256.371164-1-fuad.tabba@linux.dev> <20260806100256.371164-2-fuad.tabba@linux.dev>
 <6a92d2e40a2195099eed90179efa286295392e39.camel@arm.com>
In-Reply-To: <6a92d2e40a2195099eed90179efa286295392e39.camel@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 7 Aug 2026 11:14:20 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyfhn-08ounOrVtGoeEToyAw1MbMMA9_cF67v7vxV0jxw@mail.gmail.com>
X-Gm-Features: AUfX_mxSqna52-nLNq37ZWdcakZsFwbd8IwPxfJ_Dwi5KCENZZM1xI-WuipMZoY
Message-ID: <CA+EHjTyfhn-08ounOrVtGoeEToyAw1MbMMA9_cF67v7vxV0jxw@mail.gmail.com>
Subject: Re: [PATCH v1 1/4] KVM: arm64: Validate the host-provided vgic model
 in pKVM
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "maz@kernel.org" <maz@kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"oupton@kernel.org" <oupton@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Joey Gouly <Joey.Gouly@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, 
	"will@kernel.org" <will@kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>, nd <nd@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Sascha,

On Fri, 7 Aug 2026 at 10:57, Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:
>
> Hi Fuad,
> On Thu, 2026-08-06 at 11:02 +0100, Fuad Tabba wrote:
> > EL2 copies vgic_model from the host's struct kvm unchecked, and the
> > nVHE
> > world switch dispatches on it with no cpucap guard. A host writing
> > KVM_DEV_TYPE_ARM_VGIC_V5 makes EL2 access GICv5 CPU interface
> > registers,
> > which are UNDEFINED without FEAT_GCIE and panic the hypervisor on any
> > GICv3 machine.
> >
> > Accept only the models pKVM can run, forcing anything else to 0.
>
> Can pKVM run VGIC_V2? See comment below.

It can't, and I agree the case should go, though not quite for the reason below.

...

> > +     switch (vgic_model) {
> > +     case KVM_DEV_TYPE_ARM_VGIC_V2:
>
> Why are we allowing the v2 case through?
>
> In vgic_v3_probe() there is an explicit check that blocks the
> registration of VGIC_V2 if KVM_MODE_PROTECTED is set, so I don't think
> that we could reach here with the VGIC_V2 model.

I'd rather not rely on that for same reasoning I mentioned for the
GICv5 handlers [1]. vgic_v3_probe() runs at EL1, and EL2 reads
vgic_model straight out of the host's struct kvm, so nothing stops a
malicious host from writing V2 there.

I kept the case here because V2 is inert at EL2. The only readers are
vgic_is_v5() in the world switch and the != V3 test in
__vgic_v3_perform_cpuif_access(). But the comment says "what pKVM can
run", and that is V3 only, and is what those checks are there to
enforce. So the accurate version is simpler:

+    if (vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
+        vgic_model = 0;

Will fix in v2. Thanks for the reviews!

Cheers,
/fuad

[1] https://lore.kernel.org/all/CA+EHjTxiHyuw5EjWLha1OySm3xjRH6rbk41On+5V2+ig1FdCmg@mail.gmail.com/



> > +     case KVM_DEV_TYPE_ARM_VGIC_V3:
> > +             break;
> > +     default:
> > +             vgic_model = 0;
> > +     }
> > +     hyp_vm->kvm.arch.vgic.vgic_model = vgic_model;
> >
> >       /* No restrictions for non-protected VMs. */
> >       if (!kvm_vm_is_protected(kvm)) {
>
> Thanks,
> Sascha
>
