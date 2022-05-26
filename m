Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83B0BC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 27 May 2022 07:33:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCE4F4A49C;
	Fri, 27 May 2022 03:33:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Sax29-cWz7rT; Fri, 27 May 2022 03:32:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC8394B350;
	Fri, 27 May 2022 03:32:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50EEB4B29C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 May 2022 16:08:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9RRFYniIFY6b for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 May 2022 16:08:58 -0400 (EDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com
 [209.85.221.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5286C4B28F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 May 2022 16:08:58 -0400 (EDT)
Received: by mail-wr1-f42.google.com with SMTP id e2so3438459wrc.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 May 2022 13:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=KDEmYOOyoOP2tQlMyYbksUoCrMBj3K7WkocsVGt/GNE=;
 b=dHMXbu81V1p8lsCx1fltXdZyN0c2mVuAOYAI/LTIgHtinTY1YkSKHhFH4K2z/xFp1q
 Od+v2kkgf56CZj5kGs5hhJRFzvA2IOBEnN72WDljkbHjvlMu0T5gSmSUDDlOpwjY7OUT
 gmqz1bVuRdoBngs55rnyoQAvFbKvodBpG4gl8vr3VFsjc4Yuexub+noaUD4/v8h1P1/4
 m8YI2qINRKRJsGyzkEocy7INhgZoojFpQHo+VPqKEZE+Je/tdGzWng1W/gBoVxF0iJRE
 C3CNT5yEUHq4gy5B4AEkyvT/1xDJVkTEvR0BoisEuiJq4nPgztUPLDqvenCgNrU9Uejk
 /jwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=KDEmYOOyoOP2tQlMyYbksUoCrMBj3K7WkocsVGt/GNE=;
 b=XoZ+B6Oh5SfEnwWdUkTpfNqoGOaR61h1uRBqeiqcWTXT+AXYteXHKZYq9OjVM9Eej7
 bV+H2X1UpvNh/KkeVP1jKFVMmbywcKpP1mzEu7Dxac0ISt7Erbg/4RP1Nr8iX8w7bQZ3
 +3khCTfUvfEW4TtFpNauUGMNXU39bgfPWHlw/SgOBSMhOEmP3drobqfGT6J7a7A2oX2Y
 2m/9O3vUtSIc2AkzpFsdp5z1jnHoo8hPB3l2vBuV6T30vkSxfVE3l7sZM7oqr9CnEG/2
 EPyU2wqBah5bZUun6u2XB8RNQZ4NIHe9yEvK2RQhPkdCHfi+mAwEGhaPcjowNpuXaNem
 Aabg==
X-Gm-Message-State: AOAM530l2z+ljUC/kto+Mjvg4cKLKlFyrqn+VJtGR8az1sCG/0JfS9h2
 zgFcf7B9xtc3Gm4tz8vh7OPRLGHdw6hIwRDVEeYnTg==
X-Google-Smtp-Source: ABdhPJyaxPLGqTMtr/VToX80lhngruza82vVEBGRO0bKZQpIdREr22K3VR4QqvnYJmC04nw+CeHbap8M7tbV1tQuP/0=
X-Received: by 2002:adf:d1ee:0:b0:210:d63:6570 with SMTP id
 g14-20020adfd1ee000000b002100d636570mr3269809wrd.673.1653595737089; Thu, 26
 May 2022 13:08:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220519134204.5379-1-will@kernel.org>
 <20220519134204.5379-60-will@kernel.org>
In-Reply-To: <20220519134204.5379-60-will@kernel.org>
From: Peter Collingbourne <pcc@google.com>
Date: Thu, 26 May 2022 13:08:45 -0700
Message-ID: <CAMn1gO4_d75_88fg5hcnBqx+tdu-9pG7atzt-qUD1nhUNs5TyQ@mail.gmail.com>
Subject: Re: [PATCH 59/89] KVM: arm64: Do not support MTE for protected VMs
To: Will Deacon <will@kernel.org>
X-Mailman-Approved-At: Fri, 27 May 2022 03:32:58 -0400
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, kvmarm@lists.cs.columbia.edu
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

On Thu, May 19, 2022 at 7:40 AM Will Deacon <will@kernel.org> wrote:
>
> From: Fuad Tabba <tabba@google.com>
>
> Return an error (-EINVAL) if trying to enable MTE on a protected
> vm.

I think this commit message needs more explanation as to why MTE is
not currently supported in protected VMs.

Peter
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
