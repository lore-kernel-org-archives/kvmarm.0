Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2D530BBA9
	for <kvmarm@lists.linux.dev>; Wed, 11 Feb 2026 15:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770824626; cv=pass; b=V83J/1j1NdX7y4LEVIfHeOlirXAykqaC35s/b0V3FGGInr+DVxmlZc/RcIMWV6U6hZzKmOFxllj+2rL7Wzh0sbQXeulWr9n4v6WGDHAei0Z6nQITqe6OSEEP8lf7iZUbhL3b2dPkcDOquiaL7zBBXiTF1oo885u46FC17UuavIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770824626; c=relaxed/simple;
	bh=SPvqBAtz64fVd5LeGOVthMVnAayvTVLJhC/f1e85Ey0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P7nt6ePbH/vIrZlKxEkP70JjYbfv88IprwLf0ZFYbLwkJOopVslE75zpJiRjpHZefpnivXRKLsenU6Fgy/RO0MDxa+3ohu1Yfz6keUnOI9bUC39h8fCmKNrvi9o3J2I8urMsVN1C9k/LCxRQDREg+6J21kgqWQED+6/hcLr19C8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TtLJg47E; arc=pass smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TtLJg47E"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-79628fb5c05so37450797b3.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Feb 2026 07:43:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770824624; cv=none;
        d=google.com; s=arc-20240605;
        b=b9qrCC8SDVahiOuIOSOp0SSmgC/GYUYwhEUZd0AJiWjeBq2h/O/1LB1ebDdKCt+2Nn
         y0zgT9srBuvzL0eqVIRTtOjLpTmFv04iA8ZiAhV3yGOzeILL5OSkAL1jmT2YyHXvwYjr
         hXlAYGmWz176V8TDilxbtxXmuFkyyFpqNAhsyR7D6yCEnfDG05tSwCPH1xKsSTXQm7mf
         4KA8c7+uGEdrniZg5dYgUeToq4HFf/4NsxNRwpd7uNH5DSzY2tSMLQsx8AnCoYe9r00N
         va3AJdfosRGGeD021s4hQSAYZx1vDbGdccvF6E05d0lRRcD2JndJ3JvLqv+/zgKDFXtj
         YqHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Cwx4TMtV0+2MBlJylAWyBlGUsmVcRjrhOwzbBX1NFZs=;
        fh=QSvV0O28bK6+roTWEia5B0ofcXYAkpa7eqYmqQNE8SY=;
        b=WwE5mJLj/MPbUkOTwYTLmzTARgLpc6n0uPrQ6YWdr1bbztTnPUDeHYYAu+ez0fiOnZ
         9jiI97FVVExKk4eKDbiRHIocbimoquxCFoqIrdvWr523rmkciBNMhBnYTPAP5hqMA6rZ
         pLq+dFXiiZX6A8H28RuLAbhdiiQu0IQTs8YsRoZeR2y7OxWAF1Q63SeDbC+b8ZPy3Cej
         kT6u2tOGbbXchoK4ONKMiuRxZqmbnoSD7U9VZoExvyT04iDg9SqcN53rS2IcVUH4STRa
         G+1mDb0SgCL5MYjLf/og6uEseMJBiMExIQ+UJqrpbxAzTzdvAYmFtQv14kVU+nWWLBLc
         5lxg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770824624; x=1771429424; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Cwx4TMtV0+2MBlJylAWyBlGUsmVcRjrhOwzbBX1NFZs=;
        b=TtLJg47ET/tQnIgI6QzazWevBevc2ofRn27ROWh5NRWsF449Nwp9eZVtPc0oDwmuwe
         8kMIuPx+cd8pf8SKCiVlUeGvTKBXlZ9n52DV+b1KASvGOpR/7WpZN0vXTv9djHL/Hcpb
         ZmRPZuMIYLk2gqu2rBwVnN5ehwhSBmJ1zC+40snqhzD12e8GGy9ZTFkN/SGDiCVUxVxi
         L+l5+SdSdfy64mkdccCiYAefTGnGplXEBHnlAeO3SI4oaW+dAkEpndESHNzNP/hgbYE7
         00dlENVAMJZao3XKN1wYcxAKBVQcVpD4Kg4aXCiqNy+1l28rvBSDFFc8y2v87Vh832Ps
         VXBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770824624; x=1771429424;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cwx4TMtV0+2MBlJylAWyBlGUsmVcRjrhOwzbBX1NFZs=;
        b=GSXfa53+f+G2Ciwvnds1bX6peNUdE5yoSf8NOSJeSP9DpLhKqT6rFOWdrUBV2BlX2W
         YPnDJBekANnAIM7V/UA8dXlr7BcNsEUBQ0/uDOWe/UUU+BuZJLAtLRvu4Wt+Mp1uOpXf
         VOQcfKCuJeiHiaWOBNft4Ov7/kAZ+NKqYsZXMoEJMmT3J0tJPVZQN5dJWcD4VKnx1Ou1
         fMV5XxbX+5sCy1lCwavgyI65oCBLLbbgZd8j1N8Jo20LV0Pv/rx/I3ytdHL3JBJtJuxj
         CIICDqDLa/1Z1LjFtkzW9nx1usDgxmZByKtz0nvYMX/4yx/vlTfQOUfQ9M40Fp7s5oAq
         +a5Q==
X-Forwarded-Encrypted: i=1; AJvYcCU5nHFltPH/c+ztQAdPd21mpi6QRvZaJa8L9aRfso9HPkyVGKq3IANzkgCsGFKKMcO8whBDSAc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyLsQLBxHp4PubIg/mxQxUg9ElPRaRA1z5TEdkkmYrGo+oAfeId
	2I4wIl+z95UHE96R6F1WnZepvi352x7oD8PLW07JPbuATk15OeChj2Ayd/BlM1pndzFvQpPZW11
	TegkgGoT2ZKIgjfRp8P46BiiPI7yn3EjiORi8TcghGQ==
X-Gm-Gg: AZuq6aKHgmnDvm9omP4Yzz0rA1dN8SIwrbn1i9uJcKm13ym3FR6C0QyJUUAFVquAeCH
	R6OP7fxST6flIJ2gLvHAC83eAUuuZd69FZvRrtJp39MrTouwwAB4hNQUeJW576SphkH86gIdEjc
	gkydo6uRZH8at5ld8S4+NAbYRpSKoZtw431cAJ+09FJKawUIMm5AIVyixUpaJNt7Jp7rA9sovjM
	mJRBF8z8qnzFxuGi5oDqyAD2v8CJtFbgBS9BLLckVigbOSwKeDtq8/XM+JJcjVHyt/a29ksfQJe
	OuYTg/rXVaWSOF6WDWXLGx3gc01Y/uCKm85V3S1PPcUtqEN0VUBrEZnJvwq7ekHl9Fg=
X-Received: by 2002:a05:690c:6006:b0:796:2ee6:3f87 with SMTP id
 00721157ae682-7965f08a3a8mr55352367b3.67.1770824624573; Wed, 11 Feb 2026
 07:43:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251202160853.22560-1-sebott@redhat.com> <20251202160853.22560-3-sebott@redhat.com>
 <CAFEAcA8oi1Xs2kv66dFV9NZore+Q2vHUsgMikveVdN1c+3SBJQ@mail.gmail.com> <9b04a20f-b708-208d-1e4e-466ec30b7bb9@redhat.com>
In-Reply-To: <9b04a20f-b708-208d-1e4e-466ec30b7bb9@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 11 Feb 2026 15:43:32 +0000
X-Gm-Features: AZwV_QhbMQtjgAAFsQMaNKMcmBgssEikN0rK-YFZ8G0l_cRA-hB9h8zVvJqu3SM
Message-ID: <CAFEAcA-A+zW=QFdCY7z==+Z=xXfhJvPeyHhbG_MpEmpkQfrmaw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] target/arm/kvm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@redhat.com>, qemu-arm@nongnu.org, 
	qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, 11 Feb 2026 at 15:37, Sebastian Ott <sebott@redhat.com> wrote:
>
> Hi Peter,
>
> On Fri, 6 Feb 2026, Peter Maydell wrote:
> > On Tue, 2 Dec 2025 at 16:09, Sebastian Ott <sebott@redhat.com> wrote:

> >> +static char *kvm_get_psci_version(Object *obj, Error **errp)
> >> +{
> >> +    ARMCPU *cpu = ARM_CPU(obj);
> >> +    const struct psci_version *ver;
> >> +
> >> +    for (ver = psci_versions; ver->number != -1; ver++) {
> [...]
> >> +        if (ver->number == cpu->psci_version)
> >> +            return g_strdup(ver->str);
> >> +    }
> >> +
> >> +    return g_strdup_printf("Unknown PSCI-version: %x", cpu->psci_version);
> >
> > Is this ever possible?
>
> Hm, not sure actually - what if there's a new kernel/qemu implementing
> psci version 1.4 and then you migrate to a qemu that doesn't know about
> 1.4?

Oh, I see -- we're reporting back cpu->psci_version here, which
indeed could be the value set by KVM. I misread and assumed
this was just reading back the field that the setter sets,
which is kvm_prop_psci_version (and which I think will only
be set via the setter and so isn't ever a value the setter
doesn't know about).

That does flag up a bug in this patch, though: if I set
a QOM property via the setter function and then read its
value via the getter function I ought to get back what
I just wrote.

thanks
-- PMM
