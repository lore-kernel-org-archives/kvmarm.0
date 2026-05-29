Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D41F3C0637
	for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 09:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780046649; cv=pass; b=f193ANSj1rgscWQu6mVEYzF52RAkXZyWDCHCvG2N0hBYWJrp0OJQKLbrG3WSG1qx8TwPz0dxxF+5Kjyvobs+FHOCFcmHsARpcBap8AtjHorJjPfCndYehd457TpbgMfnXZ82xgUuH76s9j7lQ56htjekHHx3ZLKIxlCA0lvaU80=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780046649; c=relaxed/simple;
	bh=Q2bnpSYq3FFrXw7GZ83Fl1mjSbtUh+YNS96PQ4wxT/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R5Lr1k5rW7lKOqgMsEFdppl3z1mQdxzU0pq88OqgZqb6PuV/QmI9795RrATSVbxMUFtZB5J2WfCx3rugv7LgCTWUX24Z9JvOo7OpLVvly8m0VvqYR4oTYEd8JrIUyFzAPImYl/e8xkNRO70+/B/aD0y17GXLFvnpT5pzfE3hrjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wMsJ5A29; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wMsJ5A29"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-516d78ba1adso3191cf.1
        for <kvmarm@lists.linux.dev>; Fri, 29 May 2026 02:24:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780046641; cv=none;
        d=google.com; s=arc-20240605;
        b=WzWRBc07HlCn4WTSjArj9WhoVIrTz3G4rwwTu7TaAc33kqiavIEYxVUGMS9D5Fl+qJ
         eg5W/r3aUWe0wilT8LlSBa8Ch+ctEBYHJNOlFzE9/d646wIbdR3h1i+Pt8i/k8RWSv3o
         ovu/37hVlDt28z73ffu6/6VW4ahAoXUy3sX3/2+4UcEWRPxAuAtLJCHVLh/vF+JJ+YVR
         8qaq3WBJU6vSN+ZhEHesH4qhvN1McKFgrFTVsf4Www6ft5+Rbvs3Lx8OvN4RJfGwuWGe
         gkAPZA4+YnTSBja/yy2r7IOVsCob7T/W50AjgQPW6/19m5l7Vw4BSlIgsgKax++zNtlw
         J3vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=oelkwUazDs17/My08335sXF6z7eRh/StRyvI1MNEA2I=;
        fh=EC26NrkOUQZnTVoY1ePW1np6H3Pwof1dwozwI7O8kA8=;
        b=Q5AmC8Ze2P3ztqSIsedMzBBocXQdQXDfkZGrY6TyiIlZ/0Lz7HcFoSY+h4j6o9Z4fx
         tW58JB2mqZojb8mzDRbmcAGzwdH05M5ne6GpjvTnOZLpsiTAwlkCSFw1CWGM25MwcbY5
         aDO0Wzdq08uk/fCoiuKKN+Mv2wHFChjZdVvXobLSx3Iu6dfLiG4skn4OUv6gkdFx4uVy
         3LWHBQOQU1ruMhFUIAIzaR+BL4wEBaDfYf2kNrURxg+V+V8bfG/U/ses+LPMCGQvF5Wr
         44rbTJTbvtXO/ltqddNBh5y1Vf7FPR0j7HLWOupKMiPLol8a8zkRBvj4MGKFN+a2evaz
         MAng==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780046641; x=1780651441; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oelkwUazDs17/My08335sXF6z7eRh/StRyvI1MNEA2I=;
        b=wMsJ5A29N/ZzZ9nJ3tqCLD7/DILBfYn7Jh+3azApb0y9dHgemGc3Bgu2p0YTSNSdna
         8AwnYCzDJ1oQFthz86yIPnRPQN/52YuBnYbK7VcB8k9Rp8BRyIjr58v8/Gy1qCK07GJr
         eV9DsCvuqbtQrScpmv9tQ/jQecPyP+RHfJywRnzco3XwyylSg9H5TtkR9UF9GFMxf5XO
         vS25ZoKeLaheZzb0TPBkkwWMMC8z7OaiXnc80xuPSlLV/G4YEHDlk85YjtwIYn7sk7XP
         Ty77EwLuryaRFAoPs5kfeJFUXGkM3a03SJ2UTz3MqEoHwFeDdLCWQTuG1jrxAQBLVsn1
         Ni0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780046641; x=1780651441;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oelkwUazDs17/My08335sXF6z7eRh/StRyvI1MNEA2I=;
        b=h+ijjwumNgkGCMFjJhmpsEs+en52lqkRz5h24tgnB7+h9Bah0C6ozqJ3R5DjQBlPQK
         OYivgWB9IccvkQlmu7b3/jB3kK20tMdjkL0N6lECyndDfYzGsd4KdlNsH8R0DXD5Txz9
         OYUDkOzuG8nfm0Z+7MQoCkBAX5PoLmoqoatIMGrq0EAWgCmfo1WD40A+1KUN6UwYjEgq
         mQPL2Z5X9ZM7pEV8haQKfOup/qCAC2zS05WpSCMq8DdJC+GqrmQiIkXTpbRUOnWqIFH+
         EcRfx+mWiW9rnifLvzDIPtzXgXcrAwDNT8ZVjPFZjqyPfBWAVYG9GTC/ZKxco9p7IDFp
         E8GA==
X-Forwarded-Encrypted: i=1; AFNElJ/kA3oMDjpTXUzsXIW7I0N2LAiQhCFp11EdHXJdxmlvDwFFs62nV8jJGRSimHN/0CCt0VO5gEk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6X1cDkzmG2hyWgzcX/q2io+rzKyGpibVFJi5eYknZ1tdpL5iY
	UlP4npKLmYESoNY9ljYron0KKorLUjLdeQuVJETzfT+39w11K2vNucuYODJJU9Qubi8KGfpX49x
	XHMJxlyw8ONENC9dywh79pHBX2fb8K4XUFrf2LdmH
X-Gm-Gg: Acq92OESZGv8REDY4e4UaPHe9c23zaDWLU1JOLDqGaFiEmWdtqkDXrh8QV01RdNa+mt
	5nH97Iw1h6OAJzN4tZbLgbcl6DPVnrThx/9EkNqEv8UFtav5Gx5KlC0v+CgyU2Xx59sFXE2w6Ih
	sjw3BCZJGytt7KA6Z6ttVcpHYT2RcG7tGrZdZoRVv3Ugzo1L3kkTaVubQXZsaoLorAJMzK/s5Im
	AxS9J/05tmnXd5uiL1aT/lNtKuPR67w2T9uOgrE39o60VIoiq9M8ooTDNYWeRoM0iDMR84trNss
	DbgiwkEL91MU4lVq/aM=
X-Received: by 2002:ac8:47c8:0:b0:4f3:5475:6b10 with SMTP id
 d75a77b69052e-5172dd7f3bfmr5599111cf.8.1780046640595; Fri, 29 May 2026
 02:24:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260529074341.2271950-1-tabba@google.com> <ahlIJQU-1b0mayPP@google.com>
 <CA+EHjTxktk4-B6qcAOf4O26++M5s6CKkkP539s4dRBRWxZN83Q@mail.gmail.com>
 <86a4tivdh3.wl-maz@kernel.org> <CA+EHjTykVY6x+iFwSFH7MaK7rfV5CTSeFwx4cZatbB+Fuzu9Yg@mail.gmail.com>
 <ahlapmZj4wnce__B@google.com>
In-Reply-To: <ahlapmZj4wnce__B@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 29 May 2026 10:23:22 +0100
X-Gm-Features: AVHnY4Ljy9YfNO1Ea65HIA3bCO_moV5wcD8HC-aYRWg1dGnOqE0KQObhytp6-f4
Message-ID: <CA+EHjTzpKjs-xFC=5cQ33Ly2O7qkNj=yJSzOSjx0SpyBjKFdbQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Fix host/hyp tracking on share/unshare
 hypercall failure
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 29 May 2026 at 10:21, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> On Fri, May 29, 2026 at 09:20:50AM +0100, Fuad Tabba wrote:
> > On Fri, 29 May 2026 at 09:15, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Fri, 29 May 2026 09:05:35 +0100,
> > > Fuad Tabba <tabba@google.com> wrote:
> > > >
> > > > On Fri, 29 May 2026 at 09:02, Vincent Donnefort <vdonnefort@google.com> wrote:
> > > > >
> > > > > On Fri, May 29, 2026 at 08:43:39AM +0100, tabba@google.com wrote:
> > > > > > Hi folks,
> > > > > >
> > > > > > Yet another bug I found while testing Sashiko locally with fixes to
> > > > > > review-prompts.
> > > > > >
> > > > > > share_pfn_hyp() and unshare_pfn_hyp() in arch/arm64/kvm/mmu.c
> > > > > > maintain a host-side RB-tree mirroring the set of pages shared with
> > > > > > EL2. Both invoke a hypercall that can fail (page-state mismatch,
> > > > > > EL2 refcount still held), but neither cleans up on failure:
> > > > > >
> > > > > > - share_pfn_hyp() inserts the tracking node before the hypercall
> > > > > >   and leaves it in the tree on failure, leaking the allocation and
> > > > > >   presenting a phantom share to a later unshare.
> > > > > >
> > > > > > - unshare_pfn_hyp() erases the tracking node before the hypercall;
> > > > > >   on failure the host loses its record while EL2 still owns the
> > > > > >   share, breaking later operations on the same pfn.
> > > > > >
> > > > > > Severity is low (no isolation impact) and the failure paths are rare
> > > > > > in practice, but the desync is real. Both patches are independent and
> > > > > > apply cleanly to current mainline. In other words, this can wait for
> > > > > > 7.2.
> > > > >
> > > > >
> > > > > I believe I fixed that here lore.kernel.org/all/acyKhZL2di_QQ9xm@google.com but
> > > > > as Quentin pointed-out, there's absolutely no reason for the hypercall to fail.
> > > > > So I haven't sent a v2.
> > > >
> > > > At the very least we need to add a comment, otherwise, people like me
> > > > and LLMs like Sashiko would stumble upon it.
> > > >
> > > > That said, this fix adds no real overhead, makes the code clearer, and
> > > > guards us against a future where that call might fail.
> > > > Self-documenting in essense.
> > > >
> > > > WDYT?
> > >
> > > If a hypercall really cannot fail, why does it have a return value?
> >
> > Good point. If we know it cannot fail, how about just `void`?
> >
> > That said, Vincen't exact words are: `very much unlikely`, not the
> > same as cannot fail :)
> >
> > https://lore.kernel.org/all/acyKhZL2di_QQ9xm@google.com/
>
> The error would happen only if the host tries to share/unshare a page with the
> wrong state. This would only happen in the case of a misbehaving host.
>
> And Quentin's point was that this is anyway incomplete. To handle this error
> properly, kvm_share_hyp/kvm_unshare_hyp would also need to rollback things...
> The callers of the unshare should also leak the memory which couldn't be
> unshared properly. This isn't the case now, (however we do WARN_ON).

If we WARN_ON() in hyp, then I argue we shouldn't have a return value.
Or at least add a comment, BUG_ON() here. Think of the poor LLMs and
the people who run them :)

/fuad

>
> >
> > /fuad
> >
> > >
> > >         M.
> > >
> > > --
> > > Without deviation from the norm, progress is not possible.
