Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357B4130AEB
	for <kvmarm@lists.linux.dev>; Wed,  6 Mar 2024 13:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709731435; cv=none; b=QU3AV2ZszpecznFGsrvlV1R+qR1o32ECncdQwwQYK2QdNRzJMS36jxabHA0JX+dotZpT6gRI307JNfPzAsIqPSWruFzfRz2QHzQW3IXTMOKyYpbIuQgzHcewtgDYYEC3/Dn4C5AcffKRdYZJEc/YocTeKsvBsA6A6U4GMleuVMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709731435; c=relaxed/simple;
	bh=OA7zeIJZLHcgghthUXFKNKrHU5Y4QafkMwGkTbrbuK8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ngPX/PBAW+BdO7VxD/X/QSwq3rv6n34h7ylF825yWu2gZU8xKIxSueHwSgXKMsgixjeKPDewcaUQL+x4AJx95Yqs1VlE8t3FlQrRo/0L978fU/K/EEZ3TluTJ8wefSVWp800JDWFKZtMkPK7AyuLEimV/9uUtWc8O1Q3bsIsQ4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jzj+agJ+; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jzj+agJ+"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-7cedcea89a0so4164518241.1
        for <kvmarm@lists.linux.dev>; Wed, 06 Mar 2024 05:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709731433; x=1710336233; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DJnwWEva68qgKopVRsRYp5pwWFnl6Z1zVuOttOvia+g=;
        b=jzj+agJ+nqWv3GOUHU8Uf842S/LenuXRwpZFWOaDFlKP7j7wG6Z0ebAREoc62X6147
         bJzCDuXpjQh1YKBzzftc5oP0lvlF6hLzUw2NvyoomPBoku0eG1NJQhxcWa+q4pzozgzM
         +hJGMmDgSSB4eUNLAdEsNRCD9XBwwbNvmu4Xw/7quoV7H7+BDI9W1OqBMwuPdg7Fp3cy
         V2z4xarc6exC6zK/yeFAZv2M3Z5geQEjDhrB1OcBPbnj/t7d9cbzrp3gY+UFuihLUGZX
         cZgLNLHwp9PR64ht/voGUz+IH0e3Z9BEKetdJUtgGcUXmXeBXWPNUtmzlSsN/QRZS4+E
         Le1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709731433; x=1710336233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DJnwWEva68qgKopVRsRYp5pwWFnl6Z1zVuOttOvia+g=;
        b=RamUJZe44yA9Q898YxOOZ7sNBxjPY6Zo6qnwYlbwpzTWjq+Dp/q11Rhlx0y89FsPMH
         SLQ9g81Jpt4p8u2as+/DGubchGSqodHB3UqHQ59oHe743STbcQGFJ3ODicyhVYc38Etl
         GKO5VxaKwGRII7hI/Jw1HDikUuERaH+Cmk7tM7e6eA8sZlNA8UeMQahejWguLkh+1O+G
         I2tefNgCmCGbHvc6OfSF401RRLfRxEAkb1Ruwmixnj5uwhIKT+cGlM9G5sW2A/sd1P2S
         c4PA6CElh5ZvwxK90vg8K38WKomKbGHqB31e+AwFBL/rBMBN2HH2wkgvF/9R3AL6QhYN
         FQKw==
X-Forwarded-Encrypted: i=1; AJvYcCVX+QNCdsE1c69FspALfp6leT0EDquL4HV93WU+BX9+uIL7LeZbVPsdRD44gpe8yYyznWxS1BiMukF+1b6Tk0rtcDsdRmT7
X-Gm-Message-State: AOJu0YyYRhFq1sEX261SoDOuzZGKzyeRkWbodGhR418iYZ/20CzAN5rP
	3/YjTZcqsVx3qw6QvrZfc4tZfBSiUcew+cgl4qHJJsWTKzfpjFbiBOleGJcBeNx/yq+/oN1Dl0T
	CAq07337pfUGo+WSbTLIwn9c6XOo0R4bEISxQ
X-Google-Smtp-Source: AGHT+IFbLiMgejA2Kufk6Ex1H+VgzRc5NOdfS/eYlp25Tp/3aoQ6/fiyRcifkS7keDNWvSRVwaKUMT1eIPiRNGbWKpU=
X-Received: by 2002:a67:c78a:0:b0:472:d43e:9e30 with SMTP id
 t10-20020a67c78a000000b00472d43e9e30mr4919059vsk.16.1709731432918; Wed, 06
 Mar 2024 05:23:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240305184840.636212-1-oliver.upton@linux.dev>
 <20240305184840.636212-2-oliver.upton@linux.dev> <87a5nbr7x3.wl-maz@kernel.org>
 <ZehC96E3Y8lgidOC@linux.dev>
In-Reply-To: <ZehC96E3Y8lgidOC@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 6 Mar 2024 13:23:15 +0000
Message-ID: <CA+EHjTypgA=OTjexD58BzC28+DngkG1qNWuucRDZKWhNaidwzg@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: arm64: pkvm: Actually enable/disable PMU events
 when running vCPU
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Mar 6, 2024 at 10:20=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Wed, Mar 06, 2024 at 10:06:32AM +0000, Marc Zyngier wrote:
> > On Tue, 05 Mar 2024 18:48:38 +0000, Oliver Upton <oliver.upton@linux.de=
v> wrote:
> > > +static void flush_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
> > > +{
> > > +   struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
> > > +
> > > +   hyp_vcpu->vcpu.arch.mdcr_el2    =3D host_vcpu->arch.mdcr_el2;
> > > +   hyp_vcpu->vcpu.arch.debug_ptr   =3D kern_hyp_va(host_vcpu->arch.d=
ebug_ptr);
> > > +
> > > +   /*
> > > +    * The host's PMU context cannot be trusted for protected VMs. Re=
fer to
> > > +    * hardware to determine which PMCs need to be disabled/enabled o=
n vCPU
> > > +    * entry/exit, respectively.
> > > +    */
> > > +   if (kvm_vm_is_protected(kern_hyp_va(host_vcpu->kvm))) {
> >
> > This looks wrong. We should never rely on *host* controlled data to
> > make a decision at EL2 in the pKVM case. Use of this helper at EL2
> > should be constrained to the hyp view of the kvm structure only.
>
> I should've spelled this out explicitly. Looking at what we have
> upstream, there's no hyp-controlled view on a VM's protection (yet).
>
> I had imagined this hilariously wrong expression was a placeholder for
> pKVM folks, much like we have in early_exit_filter() and
> kvm_get_exit_handler_array(). But that's no good, and I probably
> should've added one myself that can be updated with the 'right' thing
> later on.
>
> > The other thing is that most of this code is going to be thrown away,
> > hopefully soon... (hint, nudge...).
>
> I was hoping Will could provide some insight on whether or not the
> 'real' pKVM hyp state management carries the same bug. Nothing wrong
> with fixing what we already have though...

Like you said, this is bad/buggy placeholder code. PMU isn't supported
for protected guests, and the "real" pKVM code we plan to upstream
(soon!) doesn't have this bug.

Thanks,
/fuad

> --
> Thanks,
> Oliver
>
