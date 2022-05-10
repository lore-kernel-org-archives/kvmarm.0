Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 712E4C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 18:07:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAC0B4B12E;
	Tue, 10 May 2022 14:07:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BLBeQ5MoHYaE; Tue, 10 May 2022 14:07:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BAF374B17C;
	Tue, 10 May 2022 14:07:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E819B4B12E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 14:07:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JIOp4my+jxCg for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 May 2022 14:07:10 -0400 (EDT)
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com
 [209.85.166.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E999349F2E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 14:07:09 -0400 (EDT)
Received: by mail-io1-f47.google.com with SMTP id s23so7802698iog.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 11:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ORtgOsgw8r2rg9kF7Y1uradtvpkvQ/KmAHGlX58ktqM=;
 b=mS3ww9V1cW77zYBJvyvW3XqVHa3f+aW39aR52QFv0bI/LfSpaFVV4wY83JCt3/zloC
 W1Xp+Tu+pnhXttjMk77/b5fMcZqmxbKS0w49TqPgM1blQ8M/X657hKz8AqPVYAJtzy6U
 SWCXzuMm4Ap/GdpQZ2YQpFJwBrSr7NyJnHz+6UsL1XcSUADB/CgBrD40XmpCE3HfUGWu
 urhPzOqZdLQgeaMsM1LbJESKQQzHAMuey2HW7vVOOxoeUTcoZsH7CBu+CCKrR2gqc0xd
 3Y8vz4en3RmhTTpzymkq79pkMxVTQmOa3fDvD/TNFUvoBpaq7w6eA2GNzDxA54TWRHoL
 6nXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ORtgOsgw8r2rg9kF7Y1uradtvpkvQ/KmAHGlX58ktqM=;
 b=MbWvLQpifj1iqaeRn3WSZyaBKZZ1DLzXVeGGwNuEKmEFJ0gBz1HJLMOKwApTQv3kKq
 Z2iwu9/PhSdGFI8zy0uKMSjxbDVI/NkSpOwXuvhUR2H203meETk71qRBWjb11UVPP8DL
 p7cx2mTrvo3E6ygZX4V5MvQ11RqfGGWvSCDYjoQ26GCvQuVPze8EhEkrndFr2nPK41GM
 B/thi1vKIaLR7HimSl3A2eeNa/OjshB6MrF5ozeCX0XqjARrQ0n6oViGmmvuolQkiRF9
 g4khY8tZkFqP0713x5fIUGg8yvmTkAHMV2/YvLINQoZPdfOZrZ5inUTY1UlkdkfH8DzV
 /8gQ==
X-Gm-Message-State: AOAM531m4F5Bt4HZW8DSpswWz1O/XOiqhJwb9pLXNMC1Ea8hKKERq0O5
 NsSh4hXssys+ErUsBuvB9Ti1yg==
X-Google-Smtp-Source: ABdhPJyQj2cSVM1u+g8jsJyGNZZME8NHngIFITUyTFs2y7kMoWa7rzeN61Z8O7CCGT8Km8vC/9rRrA==
X-Received: by 2002:a05:6638:3043:b0:314:7ce2:4a6e with SMTP id
 u3-20020a056638304300b003147ce24a6emr10881139jak.258.1652206028741; 
 Tue, 10 May 2022 11:07:08 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 y22-20020a6bc416000000b0065a47e16f50sm9999ioa.34.2022.05.10.11.07.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 10 May 2022 11:07:07 -0700 (PDT)
Date: Tue, 10 May 2022 18:07:04 +0000
From: Oliver Upton <oupton@google.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v4 3/4] KVM: arm64: Pass pmu events to hyp via vcpu
Message-ID: <YnqpyDEu6LGM+hgi@google.com>
References: <20220510095710.148178-1-tabba@google.com>
 <20220510095710.148178-4-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220510095710.148178-4-tabba@google.com>
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Tue, May 10, 2022 at 09:57:09AM +0000, Fuad Tabba wrote:
> Instead of the host accessing hyp data directly, pass the pmu
> events of the current cpu to hyp via the vcpu.
> 
> This adds 64 bits (in two fields) to the vcpu that need to be
> synced before every vcpu run in nvhe and protected modes.
> However, it isolates the hypervisor from the host, which allows
> us to use pmu in protected mode in a subsequent patch.
> 
> No visible side effects in behavior intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Oliver Upton <oupton@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
