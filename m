Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600F05381
	for <kvmarm@lists.linux.dev>; Fri,  7 Jul 2023 18:06:14 +0000 (UTC)
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-47560c8e057so831646e0c.1
        for <kvmarm@lists.linux.dev>; Fri, 07 Jul 2023 11:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688753173; x=1691345173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TqypugKQXZjj/NYiOBpd9Ow35utqsr2sWxi8Xw/IL/w=;
        b=f8AWRl/xIOmT1/naGq0CvDemv3Fh/xm/gc/2dITYuFqKGtBKaH66YsIkJzg5wqTiyN
         Qs5oONLBe2h9wO8xvluWJ/l5uGd68P2ipVEXZmJAAlYBeY2GWA4ZvOIJHUKCiMWZ/Yhg
         NX1JzexTWa0cWQwluGEXIXIg9Si8cfyRsCZJB1h72/qxdl80gVlvAautmX0cM+kY/vAO
         XpKmYBmnHZHdHpFAgp/OHapIOHoXRhIcZRR8yYH9DsfBnxV0fk5pnOaFoMdxvv8/MlVP
         RKxa852US+oL0f5OgN5fyhz/Xw1NYAFSK7Ug+JPE5OKq0KB51H/8YJvbSjwksGFmmxt+
         ntJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688753173; x=1691345173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TqypugKQXZjj/NYiOBpd9Ow35utqsr2sWxi8Xw/IL/w=;
        b=OzbOlUDetBV54dzD0uusAclSPf0HC3peFpDVupnsYWX174mEbS5un9VtPKbI2idVIZ
         bZdNRMTFkXR9VGBIaaVJRFa+5XSM/ngHNgBbfahB/m2ygGyTFUAcyWYHHE9f/Uq/oxZB
         7kOSpEr2Ois0EHNU2J85WbFMnEkyINWRNPO0kuZztVGiFAV4IOlNU0lqzXjpMR+0M0lK
         yCA76kv+7nAUM5F5OPKzLadTnelY8MJ5+W7U9YYQ0yHZ0tay6vO6gE8xF220H/NgvQUU
         Xnnq9Qo9e/KO5PdTMLZlNji+k74Dx5/+c3LUK00BJiFHpbDNDMCCqm+54lsqs8haUClL
         yvDg==
X-Gm-Message-State: ABy/qLaGbTz8uA0px12PvgHmaUYihlgEJ/F0d5wmbrpeKc+D+nVOyQpL
	F6/95LY1d/72rzwAe6HjGAohdOjAOmDnnFbaABcCWkGFDXpd9fUIE+TuqA==
X-Google-Smtp-Source: APBJJlGi7OAkQcSYaK+NBRpEFW1iek9g+QZQvOeV63zyIQ3Jo0THiIx/dzD0Ma2Z0+/rSIsa8joQgLBMdgXTia2BfUM=
X-Received: by 2002:a1f:db81:0:b0:471:2b9d:1e85 with SMTP id
 s123-20020a1fdb81000000b004712b9d1e85mr3250468vkg.14.1688753172966; Fri, 07
 Jul 2023 11:06:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-9-amoorthy@google.com>
 <ZIodEnUmwIv+Iuqd@google.com>
In-Reply-To: <ZIodEnUmwIv+Iuqd@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Fri, 7 Jul 2023 11:05:37 -0700
Message-ID: <CAF7b7mr=v4oOMOaSWd2hYGCNc0JrUoiWki0WP52xZ1CJhU_=Zw@mail.gmail.com>
Subject: Re: [PATCH v4 08/16] KVM: x86: Annotate -EFAULTs from kvm_handle_error_pfn()
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 14, 2023 at 1:03=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> We have a helper for this too, gfn_round_for_level().  Ooh, but this isn'=
t storing
> a gfn, it's storing a gpa.  Naughty, naughty.

Caught in mischief I didn't even realize I was committing :O Anyways,
I've taken all the feedback you provided here. Although,

> All that said, consuming fault->goal_level is unnecessary, and not be coi=
ncidence.
> The *only* time KVM should bail to userspace is if KVM failed to faultin =
a 4KiB
> page.  Providing a hugepage is done opportunistically, it's never a hard =
requirement.
> So throw away all of the above and see below.

I wonder if my arm64 patch commits the same error. I'll send an email
over there asking Oliver about it.
