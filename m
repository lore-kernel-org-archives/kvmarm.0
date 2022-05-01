Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB2AC433EF
	for <kvmarm@archiver.kernel.org>; Sun,  1 May 2022 06:51:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81F0C4B288;
	Sun,  1 May 2022 02:51:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WIlXesn3V6Dt; Sun,  1 May 2022 02:51:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FEC44B291;
	Sun,  1 May 2022 02:51:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2ADF34B1F2
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 May 2022 02:51:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id imiefduNNhIN for <kvmarm@lists.cs.columbia.edu>;
 Sun,  1 May 2022 02:50:59 -0400 (EDT)
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com
 [209.85.166.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 36B3A4B1BC
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 May 2022 02:50:59 -0400 (EDT)
Received: by mail-io1-f43.google.com with SMTP id z26so13528692iot.8
 for <kvmarm@lists.cs.columbia.edu>; Sat, 30 Apr 2022 23:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=VP9iXyxMxQeJllpUxlGX1hliyGmst1J0TYd1RhCYDDk=;
 b=Zj3W+S+tGghzewnNJCRlxC9wtuKtOCx10gVUhV0JAMyODHb+1EgIP6bojPrwGGhEFx
 mM9Ae/KiDyT8UycA06WfJI+5z8l9DOFWuFfhuqdkM2OQdiSeEZAe8UR+qCa/4bXyUF4g
 YmcKnrcEaA1LjfQvIYttQ1X+7311+t5BNFUv/6BQLr4VcO6Q1foBzNXgIFBOLrD4O5ir
 TprB2pyLmi7caX6JObl1AeH6DUTUXIR+UsFrktCmSagwTnz+d2KEPwJjyn09O/r3weDY
 laQQbpl7kiM56MDBCjI0a11Qm9tW59lJxzb/uTc0lvkfZmKubXcGwkAceHkT7b5RFqkb
 vuzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=VP9iXyxMxQeJllpUxlGX1hliyGmst1J0TYd1RhCYDDk=;
 b=bQS0GQB9KTlOSa9nQCyEspK0EcqNliVjKqi+08wQWDJvbAt1RKPtkto263e4UKhoyf
 8R4BjFGMRldCm/txLsyztWVZzwrtQDbIayVzVHxawfMflqSDPnI7aTNm/JXkFosd/rgK
 ufeGcYyQTsavsfDkkW1PZK22tJ248Elh4LKz83WsEOfXMeqaLWNWPSfStMjJEsAV5URn
 3ksBuftGss8oK3g5v9c5l1DPToDW7rUeLzCPIMfIni9pL4GBvOR2sKkXM2FG2twagust
 GpntcW5Cn3j7bJ88f6MZmyhueH2IUEdzD9UbOabWzi7yTHMnae0LTOeZ6kSRaGW5Xk81
 0uNg==
X-Gm-Message-State: AOAM533YMxJ4aAXvwAr8qdUPqLGPBWoRunLTa02xAKYOz237NFJFYp44
 DiV3l7uqMyaA0hcBGPJbXWe1UQ==
X-Google-Smtp-Source: ABdhPJwdrlxL4myS4vLSG3xAgNFjExpAcBG4mxrh++c3aV7BYmY6aheNfQ2x3Ro4OmnBZfOWwi0pkQ==
X-Received: by 2002:a05:6638:40ac:b0:328:6b81:f9e8 with SMTP id
 m44-20020a05663840ac00b003286b81f9e8mr2705810jam.153.1651387858005; 
 Sat, 30 Apr 2022 23:50:58 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 q35-20020a056638346300b0032b3a781763sm2066526jav.39.2022.04.30.23.50.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 30 Apr 2022 23:50:57 -0700 (PDT)
Date: Sun, 1 May 2022 06:50:53 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 13/18] KVM: arm64: Support
 SDEI_EVENT_{COMPLETE,COMPLETE_AND_RESUME} hypercall
Message-ID: <Ym4tzRL0iMxyumJe@google.com>
References: <20220403153911.12332-1-gshan@redhat.com>
 <20220403153911.12332-14-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220403153911.12332-14-gshan@redhat.com>
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Sun, Apr 03, 2022 at 11:39:06PM +0800, Gavin Shan wrote:
> This supports SDEI_EVENT_{COMPLETE, COMPLETE_AND_RESUME} hypercall.
> They are used by guest to notify the completion of event in its
> handler. The previously interrupted or preempted context is restored
> like below.
> 
>    * x0 - x17, PC and PState are restored to what values we had in
>      the interrupted or preempted context.
> 
>    * If it's SDEI_EVENT_COMPLETE_AND_RESUME hypercall, IRQ exception
>      is injected.

I don't think that's how COMPLETE_AND_RESUME works. The caller specifies an
address at which it would like to begin execution within the client
exception level.

SDEI spec suggests this behaves like a synchronous exception. DEN 0054C
5.2.2 'Event Resume Context' speaks more about how it is supposed to
work.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
