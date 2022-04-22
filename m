Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A5DC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 22 Apr 2022 06:37:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C9E54B1D5;
	Fri, 22 Apr 2022 02:37:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8MNJNrmIiUss; Fri, 22 Apr 2022 02:37:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DC8B4B134;
	Fri, 22 Apr 2022 02:37:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9385D4A369
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 02:37:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rmoi+eaLUcbj for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Apr 2022 02:37:55 -0400 (EDT)
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com
 [209.85.167.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7DFD949F10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 02:37:55 -0400 (EDT)
Received: by mail-oi1-f182.google.com with SMTP id a10so8042593oif.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Apr 2022 23:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=/Gy0PoKl83zfyCtYYuOAMZ9akW2TpZpijzEJ0nCaYLc=;
 b=H9g5Xdbgklpv2cPKWlnYJLx0v6wJrwDULfh6HafEe6OF4+ketaTF7FY/ivalBbe8BR
 u0yKELBee6aYqkv+LqwbQ4LLBSDMlAljovgjQtQM0+lQNK4P9xNiEmRn9x2HYNkBH+Va
 RlXBFfVNIV6RGF1xXWBIfK/rLUeUi1mNkdxlPQzNon1iOOoEtj6ujPR8cbqcD2Xnmdjx
 tDL9DedC97azrsAzSsdM9S3gVfn1RdvtdkTANyEbJDiMjrpsCqPCo47z5k0E23qyP+1B
 MkmDb7At3vgSedCtMGr6sywuYN6NJ2So5GMLpcGlpTMrrmiaqlBBmqa2w3EgKoM6rsSY
 Ovdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=/Gy0PoKl83zfyCtYYuOAMZ9akW2TpZpijzEJ0nCaYLc=;
 b=Aw0WdHN6esWCTKEOJcwQqySW/SMGy8/x36zAURuGpXsFx1iyDPV89lA0kLlz7K0a6b
 DgBhWEZNkcH/JhHwNXzDBW6VsVLD3KGtNVSwH+IhwKq1cJd4js3oGtaPB5DPQn21GAyP
 lXuLZu8zgtkInTw4GQkzeBvONbRQwCHLD1YRWvYdaHKsSZCrUhIEIJ59V8j2VGz1G6Jx
 gsFc429hd+WZBWlj+pBltwVG9bOdqFqUL00lnffuyAh8ikza8HH94ud2QanU6za4lrTy
 GWg4rkzPiTA2LcwnYLr8JvTXZbXweJDP3yYFtvnpLRcD/PzsBXIp2iDZqhuPQ/IY/7vs
 bghw==
X-Gm-Message-State: AOAM533azM4oz7p+y+L6REuF2FrqwtsWOBa1408OGbMVLxBYLp1oDepx
 CHDo4kT3ywHKkQf1OAVN8ozF44YnfZKk2NG0naXNAg==
X-Google-Smtp-Source: ABdhPJzEx0Qyr/AR0kCUamtLmnJEeX5smZGi6mRt3AHLeZ+1hXPbr3paI14aJNqCW7OgdXhRwAlrvapFNxD4VMOe6Uc=
X-Received: by 2002:a05:6808:d4c:b0:322:e7de:fffe with SMTP id
 w12-20020a0568080d4c00b00322e7defffemr5014104oik.107.1650609474337; Thu, 21
 Apr 2022 23:37:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
 <20220409184549.1681189-7-oupton@google.com>
In-Reply-To: <20220409184549.1681189-7-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 21 Apr 2022 23:37:38 -0700
Message-ID: <CAAeT=FwDJg5TJb048bCWmS2MM1j0oTXuf0-Gx8WO91JfRJymZw@mail.gmail.com>
Subject: Re: [PATCH v5 06/13] KVM: arm64: Return a value from
 check_vcpu_requests()
To: Oliver Upton <oupton@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Atish Patra <atishp@atishpatra.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Sat, Apr 9, 2022 at 11:46 AM Oliver Upton <oupton@google.com> wrote:
>
> A subsequent change to KVM will introduce a vCPU request that could
> result in an exit to userspace. Change check_vcpu_requests() to return a
> value and document the function. Unconditionally return 1 for now.
>
> Signed-off-by: Oliver Upton <oupton@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
