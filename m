Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B010FC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 14 Jun 2022 05:57:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E5CB4B224;
	Tue, 14 Jun 2022 01:57:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3pz4WnKwW25f; Tue, 14 Jun 2022 01:57:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EC294B18F;
	Tue, 14 Jun 2022 01:57:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C527E4B18F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jun 2022 01:57:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EPStWJKsUX3A for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Jun 2022 01:57:22 -0400 (EDT)
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com
 [209.85.167.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D0C3C4B13D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jun 2022 01:57:22 -0400 (EDT)
Received: by mail-oi1-f178.google.com with SMTP id u9so5104232oiv.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jun 2022 22:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=PEICoB6m3N8YpawGTh+jEFjmtcQM1rLpRCmzV8j/s48=;
 b=Isq/L32gYEScriGPKZHzE6t9/5yyvvxBpzQYHF8iYlCYkaiWFKtVZIGOMcS8upMT2W
 3PrQ+qffbAuptphVGJebmZoA5YWus9Phyt6/flM6SJvdfhGINbn+IcIvOAwlwQPo4ZTq
 pwO9s7fT6O4aNgVg6ChlkXGLbsw+HbfAocVf3tkeTp9zjUoeeQoIavD2pkA5J8VYzCqK
 gMbj3ztWwBbjQDWgy+BmmhGWhji0Kniv9WmHnm/xKLFBgaGW1F7DFTLncthVf4mAApQ5
 eaYw9X7u79s9Gp5UVdF5k6YcbEb2Uf7SxU2OYAuRSGQfgTkkBXg/QFSRgs577m6Ybr26
 2rrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=PEICoB6m3N8YpawGTh+jEFjmtcQM1rLpRCmzV8j/s48=;
 b=6ba8R4LhqgjXwfTlfoA+SqyXjdNPPDXENf9B6KIWkON8OeaIzKSm/Daf/sq9lClNBf
 SM7E2p7d1NAkPVG4oVvH0DnNbq4lcAB+SPxZyZcF7Id2ZxypHowBjIRFNtGj9yAunOTi
 pqJ0K0EPq0i3ASrYojnaYeFyFy5FwFaxjvMGUYKhkWW812WZ9EakNCDvm6ATN1ly5XJF
 9q6bokVAiC8C7s/+Yl2gy8Vc8nv37FKiiO0Dcxtvimo88QjMGwU0MC8mU3l9u6uxOHi7
 atjjXLwQ30dVAZ6SjycInubdejaF+2+EgFlyo503XO/RhXbfbHT9nlX9UISUMExKtUtj
 28Fw==
X-Gm-Message-State: AOAM530Edx1M4QpovtniC56DSP+vCIeDltPMqKTdFUlIShVtsWx9MuZy
 uqbsngDxIX4EWg0ywigip2SyDudjD0/OJJ89tT0b8g==
X-Google-Smtp-Source: ABdhPJxJXVon1lKUUYKHPFkwSm4YC+/Ph2Shgu5mgsRt7FRK2tIjKM+z36OMLTOLv0CXm8sWVhzyZq/DgJx5Pt3f5ck=
X-Received: by 2002:aca:ac4c:0:b0:32f:1199:5963 with SMTP id
 v73-20020acaac4c000000b0032f11995963mr1214175oie.107.1655186241959; Mon, 13
 Jun 2022 22:57:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220609121223.2551-1-will@kernel.org>
 <20220609121223.2551-3-will@kernel.org>
In-Reply-To: <20220609121223.2551-3-will@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 13 Jun 2022 22:57:06 -0700
Message-ID: <CAAeT=Fz6ik6bRURKE2mMeQzNZC5jjb9T-wz_6y_7DQ+mmyRbzg@mail.gmail.com>
Subject: Re: [PATCH 2/6] KVM: arm64: Handle all ID registers trapped for a
 protected VM
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Thu, Jun 9, 2022 at 5:12 AM Will Deacon <will@kernel.org> wrote:
>
> From: Marc Zyngier <maz@kernel.org>
>
> A protected VM accessing ID_AA64ISAR2_EL1 gets punished with an UNDEF,
> while it really should only get a zero back if the register is not
> handled by the hypervisor emulation (as mandated by the architecture).
>
> Introduce all the missing ID registers (including the unallocated ones),
> and have them to return 0.
>
> Reported-by: Will Deacon <will@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
