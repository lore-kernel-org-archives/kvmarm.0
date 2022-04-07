Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B51D9C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  7 Apr 2022 23:13:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D10A49F21;
	Thu,  7 Apr 2022 19:13:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YSQXPP5rmK2r; Thu,  7 Apr 2022 19:13:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA51249F29;
	Thu,  7 Apr 2022 19:13:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FD7649F20
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 19:13:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lyKVbKU-hxru for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2022 19:13:29 -0400 (EDT)
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com
 [209.85.166.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 932EE49E0E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 19:13:29 -0400 (EDT)
Received: by mail-il1-f176.google.com with SMTP id q10so2234337ilt.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Apr 2022 16:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=L4fHai+CVJ704RAyIzXx7UBiXAfW8hOkOCH96r8LwIE=;
 b=fj/pPVxMRNWzY1oImmsyI339onLzicgyJFmCpwHy0HDMrzBcANRgIYbkayFwqtavSx
 NX/G797eXnSjJkTsgTx2VT2rD8h0aRn5krf380dfEEEbhVC01s59b2kz7TlfVpZQ7Ul8
 y0Jns+JGphnP7Kyn8AZvIoehQ49owGizSUebyLqF8zIt7fv8EEYfG+yHwbkA0jDTd7gz
 yJhH/tJ+TpFKuzR4a2y16RcpU8ehKwTTGkRUO0l5i1nSVpLK9bWbjfvr7Ig3BdJwD90h
 G/8p4obbTu6ohpX3XQ7+LdI2flSGVqPjjdpXfcu9k/+kwnwdq+GpS7xPTy0eHVBpv3uD
 b3IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=L4fHai+CVJ704RAyIzXx7UBiXAfW8hOkOCH96r8LwIE=;
 b=MQzFx+4s3fyusqBOtD8ztD82O2jf6ZtJAjIUBMsEp//AvPnzJKCI+ZkYf1MS7iflPD
 RKbXK+f9SuMS/P9foynDajExppIVtdQi0/PMZuqqeHNgv015pZixg0Hy18/uez1IvFeq
 v+C9hTNX3iu4x+/TlITLabLpinJhaKRCCblF2BiUr+b7ryFjJnzB8EqqIvBqXt6OFMzN
 9njHsKVGaSRl2qyQ3ZJp64EWv3GEeCFyZ6pWT+wVPqJ3vHX4yYepAHJvAVTzSaz5ju9I
 NvNJ3aRznyp5YPKEuV5bXh+OAT2aahYDjZDZ1WBUbD/q4xhzHRzZJIxezA+gZFitFZlq
 tIEg==
X-Gm-Message-State: AOAM533wEBwHlXfAvXp9imcNVjME7bt8QT+GWehARgIF9MXNZeWi2qma
 K2i6uRovfAAdImJEjrVnlMVKiQ==
X-Google-Smtp-Source: ABdhPJyuIZVicGu9eRU49wNxNY7a+lyPuJiNe708yC/RuIlyD08rKZEC6MV9WSnZKPgvVIo/O005Uw==
X-Received: by 2002:a05:6e02:b42:b0:2c8:1fb1:7992 with SMTP id
 f2-20020a056e020b4200b002c81fb17992mr7439894ilu.9.1649373208819; 
 Thu, 07 Apr 2022 16:13:28 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 m4-20020a0566022e8400b006463059bf2fsm13739427iow.49.2022.04.07.16.13.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 07 Apr 2022 16:13:28 -0700 (PDT)
Date: Thu, 7 Apr 2022 23:13:24 +0000
From: Oliver Upton <oupton@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 3/4] KVM: arm64: vgic-v3: Implement MMIO-based LPI
 invalidation
Message-ID: <Yk9wFMICRqF6ROti@google.com>
References: <20220405182327.205520-1-maz@kernel.org>
 <20220405182327.205520-4-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220405182327.205520-4-maz@kernel.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Tue, Apr 05, 2022 at 07:23:26PM +0100, Marc Zyngier wrote:
> Since GICv4.1, it has become legal for an implementation to advertise
> GICR_{INVLPIR,INVALLR,SYNCR} while having an ITS, allowing for a more
> efficient invalidation scheme (no guest command queue contention when
> multiple CPUs are generating invalidations).
> 
> Provide the invalidation registers as a primitive to their ITS
> counterpart. Note that we don't advertise them to the guest yet
> (the architecture allows an implementation to do this).
> 

I'll admit that this part tripped me up a bit, odd stuff.

> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oupton@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
