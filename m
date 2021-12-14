Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 386A4C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 13:34:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8200D4B218;
	Tue, 14 Dec 2021 08:34:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M9XZkQqLzqKz; Tue, 14 Dec 2021 08:34:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EDA4407D1;
	Tue, 14 Dec 2021 08:34:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E76BD407D1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 08:34:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CnKENV+joavD for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 08:34:53 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0ECD4079D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 08:34:53 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1639488893;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Ks3M5C8EaCK4GjMRAAKSo6Eyx91OR1oex8ha7Ihy6PQ=;
 b=V1vNl5hxufoW6Uo2LjG2tv68PV21tQwFIrBsADuUJIlUXiK6BPlMOE6lFscN5fABWoH84P
 cRkxncO8CyFxlmjlOxNu1UICHzVQP96/salTnrJd7Tkp0emYf4Q+vXfLx+nCQ9F0emRp+o
 ti7EaAly2sX6NsbA+9XjJkVU0I/YjHE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-403-Ea5Llcn5MqOYvkP09SjLLQ-1; Tue, 14 Dec 2021 08:34:52 -0500
X-MC-Unique: Ea5Llcn5MqOYvkP09SjLLQ-1
Received: by mail-ed1-f72.google.com with SMTP id
 y11-20020a056402358b00b003f7ce63b89eso281376edc.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 05:34:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Ks3M5C8EaCK4GjMRAAKSo6Eyx91OR1oex8ha7Ihy6PQ=;
 b=yJx0D7DhW9iAkuCogVxhyj5Wyptt5IXp4m5TNdL8My4O5HdPW0wEwgEP+jXGfhNdHQ
 NiXUCQ5F8VimkO47WW49sNqmUsbKnPFUrNwvy8eoi3AfFTCVFx+49+bv4bu//BqFK4cc
 YKo6pcpFcSfp9lGe8znsdduFveGsbjCQltgXlTufVUDTDE9PHGQYvTH++sCQqSU2HWQV
 oR1EEhI7PCFzCcY1XniLdF8UjsJwngapNDFNj9i/70KuL+cmWQERcdUu/QTI7A67gPX7
 8TQohQv9vyTHlnld8wsdLuHJtzDtj+oqDFGqVOY3AlP8wUdVcnAiKswrIucjNRU6BgFY
 zj2g==
X-Gm-Message-State: AOAM532zA5PNoqGQrcR2I6SBuJ06fU0tgOq3Zsc9d5uYgiTso8IU8Kgc
 y5fkZguu2g/fBu95BFWrXozJB7V49imDtcl9Y3fZiKcKF87eyt/3kziuSc5cA9FsddnsPykO/R2
 nEtHHJ+vSL610tEj+GqL5NK1l
X-Received: by 2002:a17:907:7f9e:: with SMTP id
 qk30mr5484654ejc.238.1639488891040; 
 Tue, 14 Dec 2021 05:34:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwqM5EYX790yLEJfRzJAdIh/+o6T7TWGGY3j7D/yNFbJe/W4j2ZKaCKFYpB7QwPBGLGQXJupg==
X-Received: by 2002:a17:907:7f9e:: with SMTP id
 qk30mr5484625ejc.238.1639488890815; 
 Tue, 14 Dec 2021 05:34:50 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id sh33sm7367278ejc.56.2021.12.14.05.34.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 14 Dec 2021 05:34:50 -0800 (PST)
Date: Tue, 14 Dec 2021 14:34:48 +0100
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/3] arm64: debug: add migration tests for
 debug state
Message-ID: <20211214133448.6yjlbputjfabzftq@gator.home>
References: <20211210165804.1623253-1-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20211210165804.1623253-1-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

On Fri, Dec 10, 2021 at 08:58:01AM -0800, Ricardo Koller wrote:
> Add some tests for checking that we can migrate debug state correctly: setup
> some breakpoints/watchpoints/single-stepping, migrate, and then check that we
> get the expected exceptions.
> 
> The 3 patches in this series add tests for breakpoints, watchpoints, and
> single-stepping one patch at a time.  Each patch adds a migration test and a
> sanity test (to test that debugging works with no migration).
> 
> Note that this is limited to 64-bits and a single vcpu. Also note that some of
> the code, like reset_debug_state, is borrowed from kvm selftests.
> 
> Ricardo Koller (3):
>   arm64: debug: add a migration test for breakpoint state
>   arm64: debug: add a migration test for watchpoint state
>   arm64: debug: add a migration test for single-step state
> 
>  arm/Makefile.arm64 |   1 +
>  arm/debug.c        | 420 +++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg  |  37 ++++
>  3 files changed, 458 insertions(+)
>  create mode 100644 arm/debug.c
> 
> -- 
> 2.34.1.173.g76aa8bc2d0-goog
>

Applied to https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
