Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B662727E6
	for <kvmarm@lists.linux.dev>; Tue,  9 Sep 2025 08:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757407832; cv=none; b=ERP89+RlInpktLA3LsWz11h3rRSyB/7FU3OfQz1oQ2qPpRkVT/XJ8lUIksjCOH7X/A2QZNS1Yxk5XTCodsbZ8LpuwxAsoYbVt0KR7y3AcaLAuSf2jeDG/3eefXncwAPiPdTbXfNK3OsilZ1CY0H0svT6tPTBqVZpiR2uKTZHT9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757407832; c=relaxed/simple;
	bh=adMZy7eOmAHzt2uZjdZmTIJ42EyrJmwOC91Y5k+mhoo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=alEd2fe+a6OX6Hr9wW/ux3bJsj1qK9n4FlIcAw5HB9QpITUdtqpoUknHd6LVvc50l76quZOuFgj/CToL2wqYXKARu/3cDp5o718En8/O2+Rj7PnMlpzsAaBNtXKj2nGJXIwuVbw6m+glfaoWhtNI7NF33szuITxbDKDd+Sa9GIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1L5FxpDo; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1L5FxpDo"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4b48fc1d998so783491cf.1
        for <kvmarm@lists.linux.dev>; Tue, 09 Sep 2025 01:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757407830; x=1758012630; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iyQrVgT/DRDk1flErmNG0zRfCzOEya0nPwf7kHpzdv8=;
        b=1L5FxpDo+RfhEqktjodE5LT0Es8v4W39hNsU1bU7+eSfb1dlyg+eLo+ULQ53Dn4ie1
         dYG0KheYiQkw+riuR8pxTqqqZVoJg+pvRT6MF3iyGJUTL+1qbYi0xW3iEw1NsU/hhTL8
         9e/M1IrhYMIc5UYn3U/3EbVbW/RqRuPtMs/l1qlXaXuhrxh0pn4IzLfL4Rp+MxPwTOjk
         x5obuSLOwtbCYsbZQ8fgc10llI/ct8x0Mv+ynnvebDxN0HW7ENgUn9F9FE2btTWEjLug
         4v9x1MYYz6h2cH1cJ1LLYqRG2GQ6s0vSPlCzUF1J0UCcXKl50hfFGoDYNnN71ujxFmi2
         SydQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757407830; x=1758012630;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iyQrVgT/DRDk1flErmNG0zRfCzOEya0nPwf7kHpzdv8=;
        b=rhVK5ksS3J6wbMwi9zxArPKjmF9JQuO0XwIfsiRnoudPzs9+Q9O8ghw89uruspI9ze
         CZb8GtKI5WyNg1ibyXAd2CMTq0qIRxTJN7D8iB86l4qdfxc9C2lRnk9HqLZmurKB+L12
         1vWVdco/YI7JlTOsoNLj6BYpLcWzAl+ovmdxywefxekyF0UCa9vjP5RTrNpvMi9BEv5A
         +nAfW3R13f88Z3n1U2VeDZNCBs22OpkOY6pfRWgLIxyAP6MXPzLW1ddwfC2r97NHETPj
         TyFmPgrOFSZpVw8WJm2ihkn1/0mKHZ0egxkJrGxH99Zbpb/QHCbshrw8NeJKngMoUseu
         FhfQ==
X-Gm-Message-State: AOJu0YzuF/1MTmuMByYR0lBaM0nIGa/0VM503tqfIe/Uv3WxsJiOp4r+
	OBebEo+omG6vIUQfkGx96celoMJs3NiJstHMEKwMtRZnj4U7zmAVPBKFgucRSfBJ6NCo2O8bVZ1
	/yIj6Eouk4swBVJZaVrqiCS8YZEg4txzxTaOEGYSH1CTKxGF5YNS/ojw6
X-Gm-Gg: ASbGncuQzReGPl+U8aCNTSRnJblNykaJ0xgBsz79xyX0j8T2TZ9KhRJqDmxaNtr1o0K
	bb4Gj78OBQ2li8h01HTtEAlfDX+Pf+eSmIpmVQvVHJntpiQeh6ui+of9NA8MwmbhOqe/2hQkV3X
	84RfSUvH0kNa4CyjHBiP7Yy/H36sfa17O/8ZZYrHA0a0oBqG45NTAVBM51MrsX+PjSWqQx5GaEI
	xqRddgF6SMu2q4=
X-Google-Smtp-Source: AGHT+IHiI3JXPX6IbsbQYAgKJcPHbcd79MrxwtJkz+hhWiamNDxhM8IdKcNuI6OeSEaIUOp1gEuys6yJXscaruEjuio=
X-Received: by 2002:ac8:578e:0:b0:4b3:1617:e617 with SMTP id
 d75a77b69052e-4b5f83a4782mr15526561cf.11.1757407829304; Tue, 09 Sep 2025
 01:50:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250909072323.4106202-1-tabba@google.com>
In-Reply-To: <20250909072323.4106202-1-tabba@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 9 Sep 2025 09:49:53 +0100
X-Gm-Features: AS18NWB0DvPmFi-qUEdQUC9WLPdPZweoYYOUsOpJ_ZmY0_5YIMF-ZkM-TNKvlxk
Message-ID: <CA+EHjTy4fZe-Naj3wX8gZ3wTWvkAmSkEWqDfnmHcnp8T7Kz7OA@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] arm64: sysreg: Fix sysreg field definitions and
 generation script
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, vdonnefort@google.com, 
	qperret@google.com, sebastianene@google.com, keirf@google.com, 
	smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

I sent this cover letter out by mistake. Sorry for the noise.

Cheers,
/fuad

On Tue, 9 Sept 2025 at 08:23, Fuad Tabba <tabba@google.com> wrote:
>
> The sysreg definitions file has a few errors. In Enum Security,
> NSACR_RFR is set to 0b0001 instead of the spec value of 0b0010.
> Additionaly, the sign of the Enums DoubleLock and EIESB are wrong
> (should be Signed and Unsigned, respectively).
>
> Moreover, the file has some redundant definitions, e.g.,
> RCWSMASK_EL1. While these redundant definitions are not wrong per se,
> they add unnecessary code into the generated header file and could be a
> source of future bugs.
>
> Fix the Enums and remove the redundant Sysreg definitions.
>
> To reduce the chance of this happening in the future, add validation to
> the sysreg header generation script. I didn't want to go overboard with
> validation, so I only added validation that would catch most of the
> errors that I've seen, which also are errors that wouldn't generate a
> build error later on.
>
> Changes since v2 [1]:
> - Added patch that fixes field sign definitions for DoubleLock and EIESB
> - Removed whitespace fixes from first patch, since there are more
>   inconsistent whitespace use in the file, and fixing it all would lead
>   to too much churn.
> - Collected Reviews/Acks
> - Rebased on 6.17-rc3
>
> Cheers,
> /fuad
>
> [1] https://lore.kernel.org/all/20250813164506.1203851-1-tabba@google.com/
>
> Fuad Tabba (3):
>   arm64: sysreg: Fix and tidy up sysreg field definitions
>   arm64: sysreg: Correct sign definitions for EIESB and DoubleLock
>   arm64: sysreg: Add validation checks to sysreg header generation
>     script
>
>  arch/arm64/tools/gen-sysreg.awk | 20 ++++++++++++++++++++
>  arch/arm64/tools/sysreg         | 18 +++++-------------
>  2 files changed, 25 insertions(+), 13 deletions(-)
>
>
> base-commit: 1b237f190eb3d36f52dffe07a40b5eb210280e00
> --
> 2.51.0.338.gd7d06c2dae-goog
>
