Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25239C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 05:36:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B8FF61178
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 05:36:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9B8FF61178
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D6834A19A;
	Thu,  9 Sep 2021 01:36:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wI0lHokgrwM8; Thu,  9 Sep 2021 01:36:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 186AA4B0F3;
	Thu,  9 Sep 2021 01:36:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15CFD4B0C2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 01:36:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ggBO-3sji-9W for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 01:36:21 -0400 (EDT)
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com
 [209.85.166.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 904DF4A19A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 01:36:21 -0400 (EDT)
Received: by mail-il1-f176.google.com with SMTP id x10so717053ilm.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 22:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=rs5Tku62bnXK35H0Ulh2hfV6Nn9BVEa4pNd3KqkqUPs=;
 b=GMYQBh6WtXAaT5vNg8hi9Kb7xMdP3NL5qvzhh7Ue+yitvRoS2SOSlMiAf34qHAUOYb
 fxbnbFHZlBEtGe5Dl1hVQT1yA49nnbTthLHge+Pdh0Qv22zejYyAiivtcBg+ous2chQ9
 nDhlQu96I30StM5J6gnplhjyT+qyeJEVbxKpp+xMSoNAXousbBAJirlV1a/CrEyefBhO
 pI8q4n+Itugi/jPAQrP/0j2b6ipq4nt8miMBop9exEii3zQzzyPmh8XNEtoV+yW8RBS2
 zk/iIl8kAp8QzxOoM46ukJRXafhKCM9e6QCgoVq4mW5BBz+409Ab+Y+/+T7iT6wRw7NQ
 EUAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=rs5Tku62bnXK35H0Ulh2hfV6Nn9BVEa4pNd3KqkqUPs=;
 b=0SBy7PrOAIp8IUIUhIBIKarBm9USinL+RjMK0SztOCmpXloNDbYSGwDAfCfBVu16HY
 RX6LjI+qHy0tmN/uvMYIpwYKseMUvdYe4gxLpYkXgHMtVkvQUzYFLwCAL4I8nCVCH5ib
 EdQllimNTz/g7+gOk+GxP/+cHsqHG0NREzWQmWHdTDwY3wUDYtS8UAycsfApZA48zCmb
 GrD0SrCun9yO2MVFIzYR/JicPc9wIbidspaC39xRYdwsl2LL26gRyU09kd2f6bMcD8aT
 aOofXHTS1CMwYuEwP+Mj7wmzS8VDCLJeILP6/FdYzzHZ81bq+Rw6oHT8LaJbi3H3qqXc
 oI0w==
X-Gm-Message-State: AOAM531JUqbF0SHR3xKOvzDSQ9pkH7WHuWlgFyiBvomLbESfEUoQYi67
 iUXDYCyaCA8XwOuQvcK3vslOUw==
X-Google-Smtp-Source: ABdhPJz2tiiZiLS+hXn/+gHFSIX1wmyP8hppIZxSTGQIgnCL75/acuIPebWpw5ZoRZACvU+9n9ydSw==
X-Received: by 2002:a92:da49:: with SMTP id p9mr1010706ilq.89.1631165780802;
 Wed, 08 Sep 2021 22:36:20 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194])
 by smtp.gmail.com with ESMTPSA id c11sm424815ilu.74.2021.09.08.22.36.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 08 Sep 2021 22:36:20 -0700 (PDT)
Date: Thu, 9 Sep 2021 05:36:16 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v4 18/18] KVM: selftests: vgic_init: Pull
 REDIST_REGION_ATTR_ADDR from vgic.h
Message-ID: <YTmdUEcbvf/7mkOw@google.com>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-19-rananta@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210909013818.1191270-19-rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Thu, Sep 09, 2021 at 01:38:18AM +0000, Raghavendra Rao Ananta wrote:
> Pull the definition of REDIST_REGION_ATTR_ADDR from vgic.h.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/testing/selftests/kvm/aarch64/vgic_init.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Just squash this into the commit where you hoist it into vgic.h. It is
fine to glob it together with the other vgic changes since you're
dropping it into a completely new header file.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
