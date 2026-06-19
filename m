Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BE2330650
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781854186; cv=pass; b=T+qBc7bW3KUZXmKInJ8hu2VudSP5X4C0w8lVn3HsCBhGRxeC7uRyjb2W2HfcIE63jZUJZeCjsvNRphvLzCdOR+5goPWADZaL3l4QplLTBUdWnNhYyFl/NIp6R3VWd7znX3jqEIaldN/cg/wAuWQUo6sO5tATZZNwRm421bW9WW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781854186; c=relaxed/simple;
	bh=DVv5Jsf7DjPFuqS8OPq6whz30sTPdSNrC/zFcXZT3So=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dg8zHvLKObPawFh7pW+Zn6kNiuG6YW0TvgJg02ngPmTI/YEbds6QOnQ+Qa/yQNcYDPd9LTsGZ4CDneYYAdClb3n+cxSI2+OHbQR6VU114b/RRL90MYXEw54deRimuG8/R4rE1H347UdBxZAwNi7KwWksT9x2+XQGkMeFZJGDUgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o90ILt5v; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o90ILt5v"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-519ed52bcc6so89971cf.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:29:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781854184; cv=none;
        d=google.com; s=arc-20260327;
        b=RBjsqBpm/ZeKdtjA6OZOg0E8TxQ7o2t5kyG/fLqBTueahNfmpJ7vTwyAjnMfIcANJH
         kJkxRwrxgiBzPE47CtxyuMBaimkJ64eoHEI1hRtuIlZ0aWK7997ZDsQ2byxfhU2B7NBv
         olgYC7OzMlZN8tcHSNnx84rS7IKqgeF4MbVO38ZRJcp4MnhD2OjxqKZJDKryOOwTqQGp
         wpPN/9Y0xBeUw0zptDtLyWbF7pzrWJ6BWTw8zja4KR5h2qoxjh8Fj2KcDPZsxSaSLAb/
         G3OjSL02zdIzZfAqSnwT9z8/eHFwF8hZE5QdlJRAq7mDZ5EbpAE/th71ZNDHASCpZOXf
         lHNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rFt+8mgzJiyeBl/92ggs2AZvMokp6o1r/LEN2euuLt8=;
        fh=fJ79D+e8Z+hlI6JGZXymG1FyIfabMaGNyP2C31wA1LY=;
        b=WMfSxRPqXj6Co5gpk47NnzxFBs7L9OfVDUsXEJpzqf2pXC0jF2t+GDAhPoGN11fT0X
         h44ozfhStYvGCxkv/KNCr+f7qh3JzFuPuWq+QmsWMHZCMvjPcngslPkc7+8NKpm23wxX
         gyiq5W6CKEDPPDcWMS99BGCW0nAtOgazvnQPNQY6ez2o6zp7gnOOR3FN5/njKdwHzr0L
         Z1bzMa77wXJLW5BI4y7ju+8htvlIyDqxJoTxXwAdLdc5251cFCMht1fqEUsq4VyRFniD
         PYPN6M1GBtg69RYX7g7vzhDTJEPHcAP4AcQP57tEHT189WlwGY3v8Kf68HlXsWfZg85O
         EH7g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781854184; x=1782458984; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rFt+8mgzJiyeBl/92ggs2AZvMokp6o1r/LEN2euuLt8=;
        b=o90ILt5vPQpzcAeOE+cwMi+q/yuor7Xwe5UH5Hyk2QPHJIodUtVz/NzPbtCgMTu8KE
         C768HmbUzgzPabMq4Cfa7E1wn0TYsTLF25Uh5+rDmrh3zPFhZJBpmOS9B2hIfdfLVpQ9
         EJd2VHpJDTXEKE5O1hIs8SUDqVY1acqXEK21RUS0hDswz9sXB7xXOjY1nLqZ36O4o9Ui
         mhBzzKJmY7+ZwYvWjH/EmRltUOEqTGTUJiAFjuN0BJTx3uczk7uof2h0PxNV7VNFVoJc
         I9ZdPzES4d9h0ilZCAvdftP0A8eSFfJBXluCXkCr3TaCmzonAFQOtDiOO/uDLWzGM2Bh
         a9xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781854184; x=1782458984;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rFt+8mgzJiyeBl/92ggs2AZvMokp6o1r/LEN2euuLt8=;
        b=Wm8nLOt0Sv9oy9rCKbSDVo4RSQY4bC5T0+EpHly01AkWeA1RktMRVA1e4TzPZ1JGWH
         ZvU6448JDDqfwYW0O2WHmCKHmWBjXECJucXcGSIspngvfEEn+xm5zQ8tOpHK7MiMx3VN
         JCnpwKwYQlCPyUkjqEPlHiS5Ezq8SolccmbW4M2MMiIo0247zsgabwnrt6CEnXVQErax
         H7e671sRCWPgNkjqXtvMeDzA6xbDoBhkmUtWOOWCTwH5F90gUgJer9LusoFzT+vC/qa/
         519UTOX5j/vA2NI9w0aU7mJR+yZsn02n7Ke2lJxVLIqsf51BMO15dn7bS/bQdBrz5syd
         RY4g==
X-Forwarded-Encrypted: i=1; AFNElJ8A85KeutfJv2vZGdlEDPDvkSQMlx5rrrsgkKmwQhq5NVZl9HuInURpuBq3xezOvhVUdLNUWqQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxtRLV2Ye7I5BLgw5cXeY6a7T7zE/JLULQQ0Xo0G8GsXwe7Vb0t
	zpddwebyaDoC/Ze3uT75M8OpN4nLKQp3S+IOSN9wRiptOMGvK/7bbkakLv9Hs0LohulW7t18pZY
	mfVZ1Swp6UjCFpSG0NELKFV0VgKV7QkmGbsLi1JTY
X-Gm-Gg: AfdE7cmq1wmi/Q/SaotxZrqFVAzVEHiNpMZcPYkWRMF20cN9Yx7XRfiJyzFskGe0SsN
	Vp2VHLlBn8K08bSi5ffpglldKvXxGcRl7p/MtX38jzkbtX6TeREoloTjtUiXFJ000OppYgXnB8J
	RQXloY9Vf4ZEtV4ZzGYh1MC5qxLS8aUQ/bbpZthyRfJXYKn6XdvdCgVXNpwsYIV6cpY7Q1+0NAl
	XXJZAxaNsnUMVJDHIXbQNSirNzMnW3fkp1ojXYMNTlMFwMzN0WuesFsFfXsXZs8LCsKrcQVCg==
X-Received: by 2002:a05:622a:1b88:b0:519:b82d:fe62 with SMTP id
 d75a77b69052e-519e891c801mr4376661cf.7.1781854183912; Fri, 19 Jun 2026
 00:29:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260619070508.802802-1-tabba@google.com> <20260619070508.802802-7-tabba@google.com>
 <20260619072238.CBAD51F000E9@smtp.kernel.org>
In-Reply-To: <20260619072238.CBAD51F000E9@smtp.kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 08:29:06 +0100
X-Gm-Features: AVVi8Cc94G4NP6TmL5kUBsJUSfswAVcJeIUWMgnLj1_eZF8iuuFoZoPhTHjqtlo
Message-ID: <CA+EHjTxSZOwDBwVidTnjkNCzS-F9x=YXfZFQs0pB0OyJWcby7Q@mail.gmail.com>
Subject: Re: [PATCH 6/8] KVM: arm64: Minimise EL2's exposure of host VGIC
 state during world switch
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Jun 2026 at 08:22, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [Critical] Missing trust boundary validation for host-provided pointers=
 in several hypercalls (`handle___vgic_v5_save_apr`, `handle___vgic_v5_rest=
ore_vmcr_apr`, `handle___kvm_adjust_pc`, `handle___kvm_tlb_flush_vmid_ipa`)=
, leading to arbitrary EL2 memory dereference.

GICv5 is not supported in protected mode (is_protected_kvm_enabled()
gate in vgic-v5.c skips device registration entirely), so the v5
handlers are unreachable. handle___kvm_adjust_pc and
handle___kvm_tlb_flush_vmid_ipa are pre-existing upstream
unvalidated-pointer hypercalls, not introduced or modified by this
commit. They are fixed as a group in the subsequent series.

/fuad

> --
>
> commit 5fa49efc0aabdcdf925969737165624792f92f6c
> Author: Marc Zyngier <maz@kernel.org>
> KVM: arm64: Minimise EL2's exposure of host VGIC state during world switc=
h
>
> This patch minimises EL2's exposure of host VGIC state by recovering the =
host
> vCPU from the supplied cpu_if via container_of() and copying only the
> necessary registers. This avoids directly dereferencing the host's
> vgic_v3_cpu_if pointer.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
>
> [ ... ]
>
> >  static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
> >  {
> >       DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
> >
> >       __kvm_adjust_pc(kern_hyp_va(vcpu));
> >  }
>
> [Severity: Critical]
> This is a pre-existing issue, but while this patch fixes the trust bounda=
ry
> for the VGIC v3 aprs hypercalls, other always-on hypercalls like
> handle___kvm_adjust_pc() still unconditionally use kern_hyp_va() on
> host-provided pointers.
>
> Can a malicious host provide a crafted EL2 linear-map pointer (for exampl=
e,
> the address of a protected VM's vCPU) here? Since kern_hyp_va() is idempo=
tent
> for linear-map objects, it leaves the pointer as-is.
>
> This would allow the host to dereference this pointer, potentially modify=
ing
> protected guest state via __kvm_adjust_pc() and bypassing pKVM isolation.
>
> [ ... ]
>
> >  static void handle___kvm_tlb_flush_vmid_ipa(struct kvm_cpu_context *ho=
st_ctxt)
> >  {
> >       DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> >       DECLARE_REG(phys_addr_t, ipa, host_ctxt, 2);
> >       DECLARE_REG(int, level, host_ctxt, 3);
> >
> >       __kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
> >  }
>
> [Severity: Critical]
> This is a pre-existing issue, but similar to the above, does this allow
> the host to pass a crafted mmu pointer?
>
> If kern_hyp_va() leaves an EL2 linear-map pointer untouched, could the ho=
st
> use this to load arbitrary values into hardware registers like VTTBR_EL2 =
via
> __kvm_tlb_flush_vmid_ipa()?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260619070508.80=
2802-1-tabba@google.com?part=3D6
