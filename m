Return-Path: <SRS0=EEll=33=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33D16C35242
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 17:05:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC48920838
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 17:05:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hFGxKdH6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC48920838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36E324A51E;
	Fri,  7 Feb 2020 12:05:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iAyTvDGY8Wyt; Fri,  7 Feb 2020 12:05:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 278384A4AA;
	Fri,  7 Feb 2020 12:05:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07BF74A4AA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 12:05:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id He3ejqvX0wGo for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Feb 2020 12:05:03 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 088034A3B4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 12:05:03 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581095102;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=DMuEK+TxV2pdwUTaqetvEaUaSq9X4afTOtTnIjiaB5s=;
 b=hFGxKdH6huHWivqvm4zVDBa4hDhjKGRbkBdFggPsQZ4OOvMa4sDB9HJWd9+nwzI7khP9N+
 PJNe4uB6Ak/91DTPIY0JpWVWUYdHSXKYgc4yOjxMgN0IlW9wVrHEOzV6qGvNMxDJx3fVw/
 RDk8/qJQ5KjvtT2AQHND5SbeBg+JNKE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-5upk4ZPLO4KbToVWyjENuw-1; Fri, 07 Feb 2020 12:04:46 -0500
Received: by mail-qv1-f70.google.com with SMTP id dw11so1531562qvb.16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Feb 2020 09:04:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=W/mzwS+af3IHrG/BFwWznCkZFHf8eWaEKxp9UaXyBTw=;
 b=gAoriBAPprjpfZV8IVzEalCs014x21b4AdCa59u5zAtIsJDW80Ty4E2lUjr7GyzU3H
 MBFRquWGtgKK7rlohF9vbkQyzNwB0FQAqlNj57ze6RO68clXs9Ubv+RU5WDB4CTPCZJQ
 Y/Xot8EkOAFdNRM/+hUKsjmrniHFSYeNLQQJ1Qv8nXcy5ATP1rBQULoTEhrmIkofQBYt
 y1z9uN1ZvtCK5e64K+5o3d5b7wd6FsuGBulSO8jm7G8YCbILsNlrI61zMe2YnuJoLj0Q
 ysUIDbXMIwDyg4EQjwUNEIzTgGyWurgXOgMQxGP39PzbdtEDtypV8gcKGHalA+30xyz1
 GY6A==
X-Gm-Message-State: APjAAAUE4JthnUuw5+4asyyJt65IqwkZJvHloPlQr0Mfr+k4bQYNLDvC
 2bPI7ojKSyoqcfBWDbl4N9nvj+ICBHGW0G6ud1kXRy4l7mEC7Uu9XxoPqfCvsr6QiXt+qovTzuj
 KR/dVZSeXD1T+nWhwGhvzhggB
X-Received: by 2002:ac8:540f:: with SMTP id b15mr8284826qtq.237.1581095086455; 
 Fri, 07 Feb 2020 09:04:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqw1G0WIFJFzF3ZaR8RGw77pX9iDrwBoxVk9+CVkdk7fCeK283mLiW1K0rb7VbrSqZfB/uogkQ==
X-Received: by 2002:ac8:540f:: with SMTP id b15mr8284804qtq.237.1581095086189; 
 Fri, 07 Feb 2020 09:04:46 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id z11sm1575949qkj.91.2020.02.07.09.04.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Feb 2020 09:04:45 -0800 (PST)
Date: Fri, 7 Feb 2020 12:04:43 -0500
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: Disable preemption in kvm_get_running_vcpu()
Message-ID: <20200207170443.GB720553@xz-x1>
References: <20200207163410.31276-1-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20200207163410.31276-1-maz@kernel.org>
X-MC-Unique: 5upk4ZPLO4KbToVWyjENuw-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

On Fri, Feb 07, 2020 at 04:34:10PM +0000, Marc Zyngier wrote:
> Accessing a per-cpu variable only makes sense when preemption is
> disabled (and the kernel does check this when the right debug options
> are switched on).
> 
> For kvm_get_running_vcpu(), it is fine to return the value after
> re-enabling preemption, as the preempt notifiers will make sure that
> this is kept consistent across task migration (the comment above the
> function hints at it, but lacks the crucial preemption management).
> 
> While we're at it, move the comment from the ARM code, which explains
> why the whole thing works.
> 
> Fixes: 7495e22bb165 ("KVM: Move running VCPU from ARM to common code").
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/318984f6-bc36-33a3-abc6-bf2295974b06@huawei.com

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
