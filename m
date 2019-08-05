Return-Path: <SRS0=iFZl=WC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A96BC433FF
	for <kvmarm@archiver.kernel.org>; Tue,  6 Aug 2019 09:39:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C3E4120717
	for <kvmarm@archiver.kernel.org>; Tue,  6 Aug 2019 09:39:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jf1TsCUn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3E4120717
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F5E14A563;
	Tue,  6 Aug 2019 05:39:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iybzBGuXDVga; Tue,  6 Aug 2019 05:38:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04A064A548;
	Tue,  6 Aug 2019 05:38:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E16C24A4E9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Aug 2019 12:41:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Po6D+96BMO+z for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Aug 2019 12:41:01 -0400 (EDT)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D17524A4C0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Aug 2019 12:41:00 -0400 (EDT)
Received: by mail-wr1-f68.google.com with SMTP id n9so60001069wrr.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 05 Aug 2019 09:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:references:user-agent:to:cc:subject:message-id:in-reply-to
 :date:mime-version;
 bh=ABajkI5eExlI/xSitmeiji8gDOSYLzGBroq8lVBwkdg=;
 b=Jf1TsCUn3vg9vZIttQpRDxQyLLdSkih/m9y3kA3yWVwK1tHBcluvzb64DtQ25oH1/V
 xc+QogvPb9pckGM5vfsy43/UEaWPZWupWkE5UPXHzZT5A7/7Ma3dw/KrHAyWf+SIQ5pr
 Dcvq5iH0eSbCNiujtHHwUJZ240xv7Qi/eds7T8oztvpIBx2XrJ5va7rgiLI/SzDbk43Q
 Z9ORvjpxuJo5BgjdcSStKB849ChK0G8vPO2yzLZGaqzz0g6WR36X48+GBvCQz9Tay6xs
 czQE6+3WjSb7nz9cH1JuMb4iiT+97q5c2zuu/BUbeRroBVjCzNGInLsmtjQPkR05iWcK
 8OZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:references:user-agent:to:cc:subject
 :message-id:in-reply-to:date:mime-version;
 bh=ABajkI5eExlI/xSitmeiji8gDOSYLzGBroq8lVBwkdg=;
 b=a7TFhtqFK//B4sTZRwiw9Kzt9zigIOHVbBQropPFZeBGTXjlOonCOe2VtnhIlRJyov
 N9aP88get4AHbYmltHjFUTcJiYr7zxdNjRDwNTEV2Q7izQIlPNwXTjPEbGxMZXNY50j/
 BOD3yRv/ikPLE8jsUQIu6sPQPr5hhNqeUDV2S1QvaZ7r438pWqtC8hhm5MqgLCjA2iXE
 4fqPJZFZufuKaLaWXO7T0g+pPt1pLIjdpSlW96w1pLndOkWBmlqAqhRBIRd7FdRQmzX0
 xVYHlrpv3NX6DVI0NxIdE11gnvtV/ZYFvD6/vWCKfd8aEzEnfGM8lsOKbmR8IjLG4B+D
 M6Rg==
X-Gm-Message-State: APjAAAWWUwjYGGXVVIM9FOdfODx5d/jegVkhetMH9U3Z6fUREwvot0IF
 zf6AU0YBM4PmZmqS7T+cRPE=
X-Google-Smtp-Source: APXvYqz/Y6nmSCAzfJUUyNSVsxAyHbqu5I0RQoLKZMj78OsAAfjqWRVGFPKFfORnGY8ls5vKuqHU6Q==
X-Received: by 2002:adf:f050:: with SMTP id t16mr791943wro.99.1565023259727;
 Mon, 05 Aug 2019 09:40:59 -0700 (PDT)
Received: from ptitpuce ([2a01:e35:8b6a:1220:5461:8d4f:b809:4bf8])
 by smtp.gmail.com with ESMTPSA id i12sm99839220wrx.61.2019.08.05.09.40.56
 (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
 Mon, 05 Aug 2019 09:40:59 -0700 (PDT)
From: Christophe de Dinechin <christophe.de.dinechin@gmail.com>
X-Google-Original-From: Christophe de Dinechin <christophe@dinechin.org>
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190802145017.42543-2-steven.price@arm.com>
User-agent: mu4e 1.3.2; emacs 26.2
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH 1/9] KVM: arm64: Document PV-time interface
Message-ID: <m1mugnmv0x.fsf@dinechin.org>
In-reply-to: <20190802145017.42543-2-steven.price@arm.com>
Date: Mon, 05 Aug 2019 18:40:54 +0200
MIME-Version: 1.0
X-Mailman-Approved-At: Tue, 06 Aug 2019 05:38:58 -0400
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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


Steven Price writes:

> Introduce a paravirtualization interface for KVM/arm64 based on the
> "Arm Paravirtualized Time for Arm-Base Systems" specification DEN 0057A.
>
> This only adds the details about "Stolen Time" as the details of "Live
> Physical Time" have not been fully agreed.
>
[...]

> +
> +Stolen Time
> +-----------
> +
> +The structure pointed to by the PV_TIME_ST hypercall is as follows:
> +
> +  Field       | Byte Length | Byte Offset | Description
> +  ----------- | ----------- | ----------- | --------------------------
> +  Revision    |      4      |      0      | Must be 0 for version 0.1
> +  Attributes  |      4      |      4      | Must be 0
> +  Stolen time |      8      |      8      | Stolen time in unsigned
> +              |             |             | nanoseconds indicating how
> +              |             |             | much time this VCPU thread
> +              |             |             | was involuntarily not
> +              |             |             | running on a physical CPU.

I know very little about the topic, but I don't understand how the spec
as proposed allows an accurate reading of the relation between physical
time and stolen time simultaneously. In other words, could you draw
Figure 1 of the spec from within the guest? Or is it a non-objective?

For example, if you read the stolen time before you read CNTVCT_EL0,
isn't it possible for a lengthy event like a migration to occur between
the two reads, causing the stolen time to be obsolete and off by seconds?

--
Cheers,
Christophe de Dinechin (IRC c3d)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
