Return-Path: <SRS0=bMLL=C6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB3DC43465
	for <kvmarm@archiver.kernel.org>; Mon, 21 Sep 2020 14:53:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6C6FD221EC
	for <kvmarm@archiver.kernel.org>; Mon, 21 Sep 2020 14:53:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="HDivceJo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C6FD221EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C13244B56E;
	Mon, 21 Sep 2020 10:53:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fx+g8kCYR5UA; Mon, 21 Sep 2020 10:53:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B839F4B526;
	Mon, 21 Sep 2020 10:53:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CD764B520
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2020 10:53:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nhULMATNYtuh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Sep 2020 10:53:24 -0400 (EDT)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 187264B275
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2020 10:53:24 -0400 (EDT)
Received: by mail-wr1-f68.google.com with SMTP id k15so13085217wrn.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2020 07:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ZLIpTokF5jH+Cz9jMCvpZNnuTjedIPem/C8z7mI3oKI=;
 b=HDivceJohFIuElY1wucrL0+CCkoN3NxC4fZ2p+cpfAhTpCX8Ba1gW2mU/mb9AZnrVy
 sh5JgT47h6unJ4NIwLvXXd+mYlgzOTkWD8+V0qr254r533XNstBtXXjf2BUt0Buf/c94
 QhK6X5z4cXqkxdrcdWiT+f0jXSBZkeho3CHQfFTh/xnM+R0Zwca4UumZUkUmi9OKwKFa
 utiKl2UGXR17nPOg6w9G9eKfMfQ4F9o2VimjLOHh6XoS8VegLhy6trOFMCAQAGONr9/i
 t9IKGkdrn6clTQLtqBtZlvnvEJjYBqz9b12iH0Vj+gzNP23jYjxlfLO5q4/04R2TNUhh
 d3Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ZLIpTokF5jH+Cz9jMCvpZNnuTjedIPem/C8z7mI3oKI=;
 b=lJNm2FxUFhHNIpp+kd7OSuaGOl9aejcLjnqTup5G0FSJZrT5oGIeHxe+J3IRIwd8Jc
 xAjyWWSuxlEzWlzwKB/XErpupfjX+ecsY5loz9hzv1ykAtv/XVhYSfo54RN0fEd2wI0n
 tXgGH5dHYvD485YsNvovnY1XcaSd+kAVPRdMliqIbtIOEi2qGePknAUEXC4mGYls3qV8
 u1yAfa3c4iwTn1jLPcim88+E+/AMkYqJm0D6pGTZ4y0McpjjVmSIsBENk09Wx5ae/xyj
 i4DAHJ/1PdyFz5Ic0XPextyLxm9WL+9D7iZA39CdlJe/y7CB9HAn2wTYqEw+VA3jknOo
 P8cQ==
X-Gm-Message-State: AOAM532E8o4mq27v7dpxouRiTKwvQ2wFdAlxZEGL6sOFv/Ee5q7kL0Sm
 xhkT+o4oSZOFVbwHuTGuu+4sqA==
X-Google-Smtp-Source: ABdhPJzLD5pzZxn6lfDyHx+GkKqw6AZgDKziMzh+yFRg4+M/CAMHQNV666TSafzDoBpxyLcZibJWTw==
X-Received: by 2002:a5d:444e:: with SMTP id x14mr119183wrr.235.1600700002841; 
 Mon, 21 Sep 2020 07:53:22 -0700 (PDT)
Received: from google.com ([2a01:4b00:8523:2d03:e5b6:fa6a:5f89:97d3])
 by smtp.gmail.com with ESMTPSA id m10sm19281942wmi.9.2020.09.21.07.53.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 21 Sep 2020 07:53:22 -0700 (PDT)
Date: Mon, 21 Sep 2020 15:53:20 +0100
From: David Brazdil <dbrazdil@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 05/11] kvm: arm64: Remove hyp_adr/ldr_this_cpu
Message-ID: <20200921145320.2b2ipdj6w4morjc3@google.com>
References: <20200916173439.32265-1-dbrazdil@google.com>
 <20200916173439.32265-6-dbrazdil@google.com>
 <20200918090533.GE30834@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200918090533.GE30834@willie-the-truck>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
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

Hi Will,

> Cosmetic, but I think it would be cleaner just to define two variants of the
> macro here:
> 
> #if defined(__KVM_NVHE_HYPERVISOR__) || defined(__KVM_VHE_HYPERVISOR__)
> 	.macro  this_cpu_offset, dst
> 	mrs     \dst, tpidr_el2
> 	.endm
> #else
> 	.macro  this_cpu_offset, dst
> alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
> 	mrs     \dst, tpidr_el1
> alternative_else
> 	mrs     \dst, tpidr_el2
> alternative_endif
> 	.endm
> #endif

Sure.

> (and should we have a shorthand __HYPERVISOR define to avoid the NVHE || VHE
> logic?)

Happy to add this but let's agree on the details.
 * name: just __HYPERVISOR or __KVM_HYPERVISOR__?
 * defined where? I'm wary of defining it in a header file because then sombody
   will forget to add it and 'ifdef HYP' will be skipped. So I'd put this as
   another '-D__HYPERVISOR' in the build rules. Do you agree?

David
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
