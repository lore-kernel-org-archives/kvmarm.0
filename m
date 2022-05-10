Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A14B4C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 18:21:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13D9449EE3;
	Tue, 10 May 2022 14:21:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V+7K-G1njSAj; Tue, 10 May 2022 14:21:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E79DA49EE8;
	Tue, 10 May 2022 14:21:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FFAF49EE8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 14:21:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BteOP91u57Ht for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 May 2022 14:21:06 -0400 (EDT)
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com
 [209.85.166.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7121B49EE3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 14:21:06 -0400 (EDT)
Received: by mail-il1-f172.google.com with SMTP id l15so11917618ilh.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 11:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=jEeZ1p0qMMTdlOXczDvydOCwVae9LkjsCB/K2n50LPI=;
 b=D/Xk7Tc6P2TkISeL5UxkUUYsUmX8eYGS1ilTnOmMTnmwVQ9bOgGqWUrOY364O2hlO0
 lUjCFBCinsL7dqi/oSyo6kzpJN1rwIKzSfGKrnOk4JXg7aLVu4PiWUxkJMIamJLztyW9
 dNzhPuJ5RUNQ1NoH9QkYwO+cLegSjadO5zgWG51yz1MIqd+HSREhyVUEFndQknjBCWnR
 pGCuF7+bChzBdiCAr4BLgX0LhZeYFh48OEzNfBAkNpJao8c39d6ym3WrL88g3aQ1BCER
 dWBWAPUJHL//c06YQGvm2AhT0Qn4oZDBFP3KoH/1ViYgMh2j+pzBT78JSkW8XF4EwSIU
 /60Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=jEeZ1p0qMMTdlOXczDvydOCwVae9LkjsCB/K2n50LPI=;
 b=VB2aBY7F5QcSICwH5hHaP8yAQr7bd7s9/LgoGvylX9+DCptk0V7vlBWk9IyXknG68z
 /SFyhXJv5EPRyXhA2h0lYfFTTRrg2vK1BREhZFjgCVpUS39OVExTnRLQXLQfYuhLGxY3
 uQjvhH9+6s9ibHj4DmVYevo7uRJ33Lljq/vsn/KbDXJssS8mbH7sc9amE7mHmt1KyYWX
 zdG+6XCVRnvfvnw1GJniDq6RCbGJ7aPJ/NNrBxoLEQzg8UAEHAyGtPsEwljDxHyNbtkb
 1yli09Df16ak5Cntv2y9E6LaQhUfBugHgSfoMCSk1SkDJhA8VS3Byvi3BC4pIzvBoLge
 vTOg==
X-Gm-Message-State: AOAM532ZH7rlpKYMrQBnYcQELqhsDGTzA0MSwbg6Yg5AmJY6tfEu4vh7
 BEjlQZY5r0nE+vjfjpMxrFAJ7w==
X-Google-Smtp-Source: ABdhPJw/CUDfb4iezG+lEnhUkFZPmnPsUQbucW8IjzclKszEJHXdVKwxjsBeb8ERHi6Vjnk8Bzq2hw==
X-Received: by 2002:a05:6e02:144c:b0:2cf:7a91:50da with SMTP id
 p12-20020a056e02144c00b002cf7a9150damr9344674ilo.123.1652206865593; 
 Tue, 10 May 2022 11:21:05 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 a23-20020a056638059700b0032b3a781769sm4548409jar.45.2022.05.10.11.21.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 10 May 2022 11:21:04 -0700 (PDT)
Date: Tue, 10 May 2022 18:21:01 +0000
From: Oliver Upton <oupton@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v3 0/4] KVM: arm64: vgic: Misc ITS fixes
Message-ID: <YnqtDT+EebIc0eVX@google.com>
References: <20220510001633.552496-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220510001633.552496-1-ricarkol@google.com>
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, pshier@google.com,
 maz@kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

Hi Ricardo,

On Mon, May 09, 2022 at 05:16:29PM -0700, Ricardo Koller wrote:
> The purpose of this series is to help debugging failed ITS saves and
> restores.  Failures can be due to misconfiguration on the guest side:
> tables with bogus base addresses, or the guest overwriting L1 indirect
> tables. KVM can't do much in these cases, but one thing it can do to help
> is raising errors as soon as possible.

For the series:

Reviewed-by: Oliver Upton <oupton@google.com>

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
