Return-Path: <SRS0=5lJd=ZN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7049AC432C0
	for <kvmarm@archiver.kernel.org>; Thu, 21 Nov 2019 08:58:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D820720855
	for <kvmarm@archiver.kernel.org>; Thu, 21 Nov 2019 08:58:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D0fu+br8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D820720855
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47D654AEAB;
	Thu, 21 Nov 2019 03:58:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Sla+pmlRXpYK; Thu, 21 Nov 2019 03:58:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DDCA4A98A;
	Thu, 21 Nov 2019 03:58:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CC944A98A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Nov 2019 03:58:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qircgNOr1l-H for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Nov 2019 03:58:30 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD98B4A7FD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Nov 2019 03:58:30 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1574326709;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references:openpgp:openpgp;
 bh=5vo5aImJRI04ytV5bzibQHrtCMLtHTe5h3BdE00xi7Q=;
 b=D0fu+br8wr09nf74Tv4R+VXePCZAMBZ3onubnMynjmXntJlNkYKhuD5AzwxfbkKdaurYVu
 42VZIm5xDftMN48VUZIwfwd8Xv8OwGWAw5osDBAOkESc/vAdsy+kZ9NNHFGivz+g0FGHn1
 QgsYAJZFWYkeq2d2IY5BUTQqsOULCmU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-1fQK1wpFM06SR5IM7eXPGQ-1; Thu, 21 Nov 2019 03:58:28 -0500
Received: by mail-wm1-f71.google.com with SMTP id y14so1474312wmi.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Nov 2019 00:58:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=sCmKx0alGdWS1edtMABKHywlxEIqQr0SHiAwqlNmhiI=;
 b=on2q/bbOodsqX2OLhpuZuOIHAyKDwuzmFlrKQLGAU72T2DgX8oSmzh6c27YvYqq+sT
 w+eVUud5ov9n4+aVIejZnnHd98bHFcLBm25xApYNRQ2tDdFDkFq/JSg/YqKv6LsvvSdW
 QN/iBqunHXIwrdsWGcdFLCwYutQsRQma3b34cDhv0qvrphZtr4xemuhb1Lkwa0CkZ6iz
 Bmazu2oRxRWO9/OvnX9KDwqnzZ9NyB600dmiinQ7+wedmc+uEkoDs7EkT273YMgRDUBK
 Dvy2ggEt2smQ6XYmMLOwdlp+XCwIRgnaJcGzt463tiSDu6/FzMrJft+iy/hMaMuEKc3m
 B1XA==
X-Gm-Message-State: APjAAAWdKEChzZdDf5sM+rebU3g8Se1onKJmnXKRoon3URVsUyKEkkwP
 Bej/9JBaXtxxBVLW6T6CS2YaW7CgMnJrJdypBPtlqAjR54cJIisUWwNS5JmScKDa/gDcLGT1hTF
 jq9wVk1/9uyE8gn0UEkEIMN5Y
X-Received: by 2002:adf:f108:: with SMTP id r8mr301756wro.390.1574326706546;
 Thu, 21 Nov 2019 00:58:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqxzhpPUBrdJMs3GDqJXStN+Ui3qdExeHo3qQr+2CCFWqDTetXUpI0bjUjmWgLMo+sRzmAIhrw==
X-Received: by 2002:adf:f108:: with SMTP id r8mr301721wro.390.1574326706249;
 Thu, 21 Nov 2019 00:58:26 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:71a5:6e:f854:d744?
 ([2001:b07:6468:f312:71a5:6e:f854:d744])
 by smtp.gmail.com with ESMTPSA id r25sm2130012wmh.6.2019.11.21.00.58.24
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 21 Nov 2019 00:58:25 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm updates for 5.5
To: Marc Zyngier <maz@kernel.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?=
 <rkrcmar@redhat.com>
References: <20191120164236.29359-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3cde0da8-62a5-d1a5-b6b9-58baf890707a@redhat.com>
Date: Thu, 21 Nov 2019 09:58:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191120164236.29359-1-maz@kernel.org>
Content-Language: en-US
X-MC-Unique: 1fQK1wpFM06SR5IM7eXPGQ-1
X-Mimecast-Spam-Score: 0
Cc: kvm@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Steven Price <steven.price@arm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
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

On 20/11/19 17:42, Marc Zyngier wrote:
> Paolo, Radim,
> 
> Here's the bulk of KVM/arm updates for 5.5. On the menu, two new features:
> - Stolen time is finally exposed to guests. Yay!
> - We can report (and potentially emulate) instructions that KVM cannot
>   handle in kernel space to userspace. Yay again!
> 
> Apart from that, a fairly mundane bag of perf optimization, cleanup and
> bug fixes.
> 
> Note that this series is based on a shared branch with the arm64 tree,
> avoiding a potential delicate merge.
> 
> Please pull,

Pulled, thanks.  Note that the new capabilities had a conflict and were
bumped by one.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
