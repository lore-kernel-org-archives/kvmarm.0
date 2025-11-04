Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D186320DD52
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 15:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762270301; cv=none; b=l3b6PlCo/LA/xwAw5AnP6FEtLfjXaadeyvxpH1QCulTXl/XY248SRFV5No3hWqYt633YABkPcTd2jbXo7eT7CLdGeKG3VowdsXLw2INWLQzT+GYWwwWs9U9zb1p8BUzxtStt/+dfazsgRirBLA9WBPk/mctendjorha9khuPmv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762270301; c=relaxed/simple;
	bh=cw9zaNJDOKWLXdz9grydVSG9cp15N8CBG56gvwobMfI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n76PRuRBBfsGYpq1W48Dj/4/TxQWio+sz+4ZV8QJ8iW0+M8VAgrRBEQx/c+h2Hb65s6PGZkqxDtKQIRB+x4gBS7sW/W81ZBObqbjMio7o66a4MeLTV9bT/y+gLprLNkNjFbkNFTdQr4NWrEoyV7C2zVcLbtH66JDomw5kiPK1og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lcw3MSxW; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lcw3MSxW"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ed0c8e4dbcso377151cf.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Nov 2025 07:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762270299; x=1762875099; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=21lGBZHN6RDH3gDJV/VR93+uRMqtY4vgBTT2MKuRSr8=;
        b=lcw3MSxWbQz7mvMhR3HNoqN+prx1TVHSKslbtmJMe18CINWo5ES1q5bjB0P7/yNpTL
         Mg8/gJb2nNS9QRBl/B7YxoRAAPiH7gE5Xdjn0BB/8xPECpYd+X03Z+YPT3xrmWJfYjx+
         A6eb/Ay1UhdFFPUVAqZzzchcBulwwSW8uWCH9QeClitq7tirRQNJ9VJV7CpYN6XLv/FA
         5DHz60JJe1jrp2cepU4t3Ly9ffQQ9kn1KT7D7Vk5ws7B0HAXD8tiyNe68gHbIkiIrA6w
         P2zf1ZCbcNd3lgGEkj5DWWY7BJk5o54o95dntmK1LID5kcheVB1U58HrbWQMiDF07BMW
         Fx9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762270299; x=1762875099;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=21lGBZHN6RDH3gDJV/VR93+uRMqtY4vgBTT2MKuRSr8=;
        b=G5MvM9YbxL2W4lMzd27HVddLYpe3jf9+rw2enjceau2nR9byYbt4lvimZOUN8bojST
         yMQ4h5SDL4v+WLAVU+lDRR6OzsJZwfcWRO1k2qghQM+B3nzv8qFH/ABsdXCgYkvCZpED
         y/VK52mOiGvekf4DPNd9OMrmUtwRzig6tYvB5NIHaqBAWU4NFxwcLLKTJhUwV0a5gTTN
         kowXtHDWngqL/EJe7e3o/JrNooieKLhvuzY7699mv5EI6ZXn+zNQyXU/Z+jZ40xuMjXO
         qeVyoUJgkF6Ezzqvl1FLXVHSnJj1VGRxOXgD0UC/bwaZpRW/rcgOriKa1yXzXEpT3lia
         +LMQ==
X-Gm-Message-State: AOJu0YxfkHW18/sEkv9IyldIHlcCP/eqz5LoTaFLL0tlwIpknLsZs6Dy
	RSn81IdIV8YJWumP/BzrretLqRUws8P/QWL5Rf1fDNm5uQL9Bli/aduQD8nsXGzQWrn2zdAMBmL
	fvO4uSIoKuJZnRHf/5B9FT2Hhzgok+bPhs0OgBBhLKlttq8NLH/PlagRt
X-Gm-Gg: ASbGnct6q4UbKldOblcRB5OhxD4tO1/bKwUBbyT3waEpOapHeJTiiexXyEFyceahFvQ
	Tobl7rxR9ORJFFj5vmVRs+ZHLbYxzhfqjAE1VN0DzgM2pWf04DWcJgcJ9Z39Foti+u2MFFd5MgO
	PzNLSCyAo3LDq8j/leptcWk/fcdx7tsHLOW+hhQg74i2EdhZUNAVJFAtAk1Ctw8KlSU7ekX0AmQ
	xHyKWeYmTHwb+oop7VK5lYET2srhCgtwpIegO7dXvST+aKbi06qQ8+PwmjIhDYIbe/0YhfJQN2a
	pxar299bcoEvlD4qdvpjOx1V
X-Google-Smtp-Source: AGHT+IGKUuRG3ZTQJQjA7fDbzPjiK8c0XLTuIcGAohK8BXI9QMN8hTTl8zf+znwMZHD4+Rf7gf9pYImYFgIOVtGiADE=
X-Received: by 2002:a05:622a:1794:b0:4b7:9a9e:833f with SMTP id
 d75a77b69052e-4ed6384651fmr5720961cf.7.1762270298370; Tue, 04 Nov 2025
 07:31:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251104125906.1919426-1-tabba@google.com> <20251104125906.1919426-4-tabba@google.com>
 <86fratvmy6.wl-maz@kernel.org>
In-Reply-To: <86fratvmy6.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 4 Nov 2025 15:31:02 +0000
X-Gm-Features: AWmQ_bmmcY2AsnQ7Tf1DOOd59RP8aCPwMHtrKQbQXLvPulNWGjrihLSXD_qNPF8
Message-ID: <CA+EHjTxTBxR6VN_JtA-ga6QrZ-FL=AKyLTDr9vWSqfkdwjz9-Q@mail.gmail.com>
Subject: Re: [PATCH v1 3/8] KVM: arm64: Enable LS64 instructions when
 supported by guest
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	vladimir.murzin@arm.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 4 Nov 2025 at 15:26, Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 04 Nov 2025 12:59:01 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > The FEAT_LS64* family (FEAT_LS64, FEAT_LS64_V, FEAT_LS64_ACCDATA)
> > enables support for LD64B, ST64B, and their variants. If a guest is
> > advertised these features, KVM should not trap accesses to these
> > instructions to EL2.
> >
> > This is controlled by the HCRX_EL2_EnASR, HCRX_EL2_EnALS, and
> > HCRX_EL2_EnAS0 bits. When clear, these bits trap the corresponding
> > instructions. KVM did not set them, which would cause guest-supported
> > instructions to trap.
> >
> > This also created a state mismatch for nested virtualization, which
> > validates its own HCRX_EL2 value against the features advertised in the
> > guest's ID_AA64ISAR1_EL1 (in handle_other()).
> >
> > Fix this by checking for each FEAT_LS64* variant in
> > vcpu_set_hcrx() and setting the corresponding HCRX_EL2 enable
> > bit if the guest supports the feature.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
>
> Please see 20240815125959.2097734-1-maz@kernel.org, which has a large
> portion of what is required for this to work. Just flipping the bits
> isn't quite enough.

I see that now. Thanks.
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
