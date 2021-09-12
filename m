Return-Path: <SRS0=OUTu=OC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C028C433EF
	for <kvmarm@archiver.kernel.org>; Sun, 12 Sep 2021 07:05:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8F87E61211
	for <kvmarm@archiver.kernel.org>; Sun, 12 Sep 2021 07:05:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8F87E61211
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D40AF4B13E;
	Sun, 12 Sep 2021 03:05:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ofZmlm1rnThh; Sun, 12 Sep 2021 03:05:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B09004B1E2;
	Sun, 12 Sep 2021 03:05:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D4CF4B1DC
 for <kvmarm@lists.cs.columbia.edu>; Sun, 12 Sep 2021 03:05:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hn8z9+3F7qZv for <kvmarm@lists.cs.columbia.edu>;
 Sun, 12 Sep 2021 03:05:39 -0400 (EDT)
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com
 [209.85.214.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 487EB4B13E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 12 Sep 2021 03:05:39 -0400 (EDT)
Received: by mail-pl1-f170.google.com with SMTP id o8so739610pll.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 12 Sep 2021 00:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=QNpLnODXD3KMtIbZW9KjXBpb07wZf63uyRmwVpvp6IQ=;
 b=KS9b8sBMavB5IM/KGnAEWQlq7rcYa7fBiZ5xKnoY5Mef+At1q0wBN1hS5AW3dW2KDO
 ltQOtyijdPz/7V6QMRljKwGSuEFjsbpJMI6YxmWvpOAves6kHDJWe21DjFj3blFFVBBE
 NcAhkl+fdkP1Ww5MHqA9WYZ/SF6fwCG5QXN8cmxHVvPgFGWRWHivy4WoHgh54LuOrNo3
 RSwPItRUJ7XTMyUztTyG/md/pUYZ/siRmme/3DH8RLknVR7UfxtItclIvSa+P6X7KNu3
 n9A0utp4LeyUrBdIQIBFpsm3QKkjqS5IdCUiD4LyoFRHpwUsJQsAmJDslrNJ0et7xf9T
 SUQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=QNpLnODXD3KMtIbZW9KjXBpb07wZf63uyRmwVpvp6IQ=;
 b=3YuVEkdctPN99QfYzXFHlT2p/lLfURNRdXizAYrXcnOOHc/xENDfLuLcNPdf1TScl1
 ceDZoZ688DW8v/ZrRfA0cR0JIwJFgmCH/Ubksj7F+GX4nTwQ0xvwQcJUuQg5XeZA4+o9
 PNM4/7lw+wmv5FCSXoOHmkmIPMTTOXGElxQR471TH5/ObvqOsnxEnxISepnFSiUOh+qp
 As+oUJcf8RVNExhDqTa8z1qy1ktGC6qJ1YkShOyBBpUKvBAcV7bZWJvSHo7FByDn6iMy
 R+QVjQDroYn1cyNjLBFHAvdSOgDKJEMIqgilnvaSeM0CQkC6GX4q7V8msn3frXrwA4QA
 tT0g==
X-Gm-Message-State: AOAM533gjvolWOzabyH2OwGxuAaYaL9Rs1xA5qhuRP/I7J/3z7dUF3Bw
 UcdAhP7lnHUiLZT5y+mY42wF3hd6lEUbAZzJxZbDUQ==
X-Google-Smtp-Source: ABdhPJxdd84H/DsUuLXrFrUnP2cmjHGR9a4YQXIREdU5uKBdYshF8RaY9FwAu6nWcCNUpa+wHuqKzNOa3l5fx2WmBN4=
X-Received: by 2002:a17:902:654c:b0:13a:5661:3d33 with SMTP id
 d12-20020a170902654c00b0013a56613d33mr5222572pln.40.1631430338122; Sun, 12
 Sep 2021 00:05:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-10-rananta@google.com>
In-Reply-To: <20210909013818.1191270-10-rananta@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Sun, 12 Sep 2021 00:05:22 -0700
Message-ID: <CAAeT=Fw0Z1USVpdi2iRMRq0ktTP4+VFzfy31FWV36VPOCTq6_w@mail.gmail.com>
Subject: Re: [PATCH v4 09/18] KVM: arm64: selftests: Add guest support to get
 the vcpuid
To: Raghavendra Rao Ananta <rananta@google.com>
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

Hi Raghu and all,

On Wed, Sep 8, 2021 at 6:38 PM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> At times, such as when in the interrupt handler, the guest wants
> to get the vcpuid that it's running on. As a result, introduce
> get_vcpuid() that returns the vcpuid of the calling vcpu. At its
> backend, the VMM prepares a map of vcpuid and mpidr during VM
> initialization and exports the map to the guest for it to read.

How about using TPIDR_EL1 to hold the vcpuid ?
i.e. have aarch64_vcpu_setup() set the register to vcpuid and
guest_get_vcpuid() simply return a value of the register.
This would be a simpler solution to implement.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
