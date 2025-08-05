Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4715F274B50
	for <kvmarm@lists.linux.dev>; Tue,  5 Aug 2025 15:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754407280; cv=none; b=eT3krQf18TKB4HwszxfugeZMrc6O+fDYyMpsNbZGtiSCOuP+a0QQAFY6yklBkgAoES52tW6PIxdEZB9/SX+PlsD8MuFy057u8fLykW9bic9gkYNagSBlu3WLazc0fzckuxsUQ2QozsU+VbjlOv3BAdtu4bDHOGlfe8H4J9P/Css=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754407280; c=relaxed/simple;
	bh=r1Meg3SAhDcH+nnYjimoBkrTZ4UUpLXDaIJfimD1+eA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R5n5Gb6ylUFJOrbGhS+zzWZYsZ3v/IMuwwY/9ymCiC/6fSVBJ6tDf/RvIOLEgp8okGWlQN9L9FMltfv+/KTDIupSfYKdo9vXxeZW3OUSemAPIJthqqRQuKvHS6y4diKsixZvKXf2vLmF3Ue4q1YORabYSyuoDICnbOOK2nnNk+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LZylkyjm; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LZylkyjm"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4b0673b0a7cso628111cf.0
        for <kvmarm@lists.linux.dev>; Tue, 05 Aug 2025 08:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754407278; x=1755012078; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r1Meg3SAhDcH+nnYjimoBkrTZ4UUpLXDaIJfimD1+eA=;
        b=LZylkyjmzGw9dmh4Wf60VQZAWpIEFofMmowySbobjdBrhNF1JPKeZ1tWL11z/fFOfP
         NjsLv99sc4A5zohZHDCUHDsNpyqzyV8WNJHjhtjfTEI7VQiJsMpcSePUd4DVHsrtc85b
         MYXE0io/2jV+A3pSSUO6oL5tghC+goCORwYAU8qlDZVni9/YX1xlQ9Nv4AHOZDFscUmh
         6qnoWHCspusKcUl5lAUxIOAtj87Fviz/USwrJmmVl65d++mhGuw7n/xVwOunrVCb6jCe
         1T66doGHq65uoiKW3oUevFj61QBf5zRhddqPw66ci4dgkyv5QsHf0/x0DZBderdYI2rm
         TAAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754407278; x=1755012078;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r1Meg3SAhDcH+nnYjimoBkrTZ4UUpLXDaIJfimD1+eA=;
        b=U9UO7FZxRF8JjZsqVDw10SRc7KvtOAdfFlqUWnxEeWRw40/0F1rOQSk2wgWdvs2kPP
         tZCZeerXo9XQ6sMKoYpPQ40C6ngDP469DXFfiXlorXJUU43I8wWJordJZp9/iBGRLlrx
         AY5j6BpOIGWW/6snHoCH4+qOhTtoxgw+q7V4pM1gFADkv/gBrjFLS5A3PRKtcBXrMZUY
         waB9v1KfQcZjaEb8IU7J/jIKY0WQGJLJugVDEXBuS9kRdi9umytBbfsdNzFuy8cCKSR5
         n5maR4o3KNBk01Qy3b7ZfuxDDftpym2/wSmEIL/ixTvCgPK9oyu+WpZrMxclo/5oTq+T
         rWHg==
X-Gm-Message-State: AOJu0YxZ8Skk9cyYBzwYCJJZJ+RDIWr2WCi/Zv2flVTw3d5+gvN01RL8
	sjnoC6XL/vPoaKwJuBiK+TjAFqm4nbV0e1gT4Ao+f44byFy63WNs4fAN3Of6RxTYljJDDvyA+/P
	iG9msKH3+cIxKGiCnVyFfxIz+nGPTxIWQ42b+dZyL
X-Gm-Gg: ASbGncu3cecHF6qNFitF8aA6CzK0xnZsSdCBtgtXdQFHqgXz1I6+zgvleZshRIZhBDg
	qICtT0owpfiPwF3yVxSGUh9yVhbmHT7VZ3W7U6MIl5AklpRGaCCL9aHO8oIf0XNW9LOHqdEdojs
	ANRCq+m63u1LPoYM4vQpzj1+bjj7EeJTu/MEwhPXlDuvjwaz6mewRibFTx+xNQCnR/rNZQHzYlc
	Y1WbasJ
X-Google-Smtp-Source: AGHT+IHgagTKXL9FPCp0iCD+9/acHZKe2CgULwhUdyzE2hK/zZEFw7jdeh3IdiV4ujAdRnhlDN2PVWoMVQsJW7Lprbc=
X-Received: by 2002:a05:622a:4e:b0:4b0:83a3:9bac with SMTP id
 d75a77b69052e-4b084ffef47mr4060521cf.17.1754407277855; Tue, 05 Aug 2025
 08:21:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250805135617.831971-1-tabba@google.com> <aJIXqmv1_0djt82y@willie-the-truck>
In-Reply-To: <aJIXqmv1_0djt82y@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 5 Aug 2025 16:20:41 +0100
X-Gm-Features: Ac12FXyEbwP4ln3SJ6qXyIbaadtTPQ9r3wm2Hpipb7fqLA4duSGS1qyDxnJRhTc
Message-ID: <CA+EHjTzTikJjhHAse0vKBwn2Gi=nOR9MKjQDOFL2H8BxBL3JGg@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] KVM: arm64: Fixes to handling of restricted
 registers for protected VMs
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	vdonnefort@google.com, qperret@google.com, sebastianene@google.com, 
	keirf@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Will,

On Tue, 5 Aug 2025 at 15:39, Will Deacon <will@kernel.org> wrote:
>
> Hi Fuad,
>
> On Tue, Aug 05, 2025 at 02:56:13PM +0100, Fuad Tabba wrote:
> > This patch series is mainly about fixing issues we've encountered in
> > pKVM (in downstream Android code), related to the handling of protected
> > VM access to restricted registers and injecting undefined exceptions
> > into a protected guest.
> >
> > The last patch isn't pKVM specific, but a fix to the vgic-v2 code
> > encountered while fixing the issues in this series. The issue it fixes
> > was indirectly introduced into the code with hVHE.
> >
> > Based on Linux 6.16.
>
> Thanks for putting this together so quickly.
>
> I left some small comments on patches 2 and 3 but, for the sake of
> transparency (I already mentioned the GIC thing to Marc), please can
> you add:
>
> Reported-by: Will Deacon <will@kernel.org>
>
> on patches 1 and 4?

Will do.

Cheers,
/fuad

>
> Cheers,
>
> Will
