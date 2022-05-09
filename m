Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD509C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 19:42:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5165D4B1DD;
	Mon,  9 May 2022 15:42:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wut880BvXuoX; Mon,  9 May 2022 15:42:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 472224B27E;
	Mon,  9 May 2022 15:42:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0A3A4B25C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 15:42:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CPX5zRito34u for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 15:42:03 -0400 (EDT)
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com
 [209.85.166.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A51734B1DD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 15:42:03 -0400 (EDT)
Received: by mail-io1-f50.google.com with SMTP id e3so16450088ios.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 12:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Poa/XHm7RBN4xu5ZBa3++e981PAjmsDa6rgsRLJgu7w=;
 b=ZybCmqqLa1TXyZNi4b3l/y+waQtDIJl1O2rSQSLXULMuqCxRquDqdOnQ9MJABJ5dJ4
 Lig9ZFr5vUEjgOZZcuTI/2Aj+yGJ8Rz3UxN1zm9gItowLdHtweUv1VVCDmoqhJCEX752
 ltRBpDclvHOALnxo7ns4y2DP5QFHrIxbjangGc4ssU7ho1z/LmpqpZ7GM+FyiE/0AqZl
 9utpIboDZ6oJjPYtUZEqy+DYTBzmJ26jmoa1DhgVjNCpbTeI1jWY6M4Nw2MGiSUwfSHt
 2jyJxsLouEMuRKr9ZJS+0v1rbDw/E5zxOgzm8FiAuE0x4aC2qQOMidJMW9M/m5u+Whcc
 LW4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Poa/XHm7RBN4xu5ZBa3++e981PAjmsDa6rgsRLJgu7w=;
 b=5rLoCyNWpswnbUO7kOFRyowri0sSWZlqBGOZQZdDobpKXQ9JrRC5mG5ohlZN6yscrt
 2VLtH/nar58IIpfPVwf90tkW4m34ESLzOCZbJAaLyunoucbqn+0BiLmM0RDNVbMmg5Kc
 c/T+HhfwUm8O9AmqDOx+b+hcnX+s7DvCXYk2LgrjamVPsQxW26qoRsdvSBXXseraXqee
 bEI5+SWUKQ5eqTOQ9Ff+wzD3+4S1+w6D2xgNbxMZe63QCSApBLmehMZNtPGienKM8zR7
 A75LMVL///ruRjG3vDLdy6N+EvVjJ61qHv/3uRrM5oqMzWuxn4ce3IOh1EZSNrqVxBV7
 qDxQ==
X-Gm-Message-State: AOAM53230oeVqtk4f410pCOihQa6xWGvTTV41K+/68qFy6NVizkf834P
 HruxhjhU19E7p37iUBw3K3P2xg==
X-Google-Smtp-Source: ABdhPJyIaumo9OpsjTZGZAa6Fc/t5wdn8DelO8YshGZ5bop4Hjf3UFhrGxCvrh8CKvKq0KEyTq01sA==
X-Received: by 2002:a5d:94c2:0:b0:60b:bd34:bb6f with SMTP id
 y2-20020a5d94c2000000b0060bbd34bb6fmr7003799ior.32.1652125322583; 
 Mon, 09 May 2022 12:42:02 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 p10-20020a92d68a000000b002cde6e352f4sm3351915iln.62.2022.05.09.12.42.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 May 2022 12:42:01 -0700 (PDT)
Date: Mon, 9 May 2022 19:41:58 +0000
From: Oliver Upton <oupton@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 1/4] KVM: arm64: Wrapper for getting pmu_events
Message-ID: <YnluhqLgARCcERkh@google.com>
References: <20220509120330.3043773-1-tabba@google.com>
 <20220509120330.3043773-2-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220509120330.3043773-2-tabba@google.com>
Cc: will@kernel.org, maz@kernel.org, catalin.marinas@arm.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On Mon, May 09, 2022 at 12:03:27PM +0000, Fuad Tabba wrote:
> Eases migrating away from using hyp data and simplifies the code.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
