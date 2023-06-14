Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5824A11C85
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 19:22:03 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-568a85f180dso12404037b3.2
        for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 12:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686770522; x=1689362522;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i/rLVEpofQ0Syv4PvfDPAbW4A331iFXceGCzfBsi28U=;
        b=PL2iPrBfrKmXWEBz7vuBuxZ7qckazlTTOs/xfuGuY4nyuX0n5iZ3LQlNbqI01Sj3sL
         lH4BASGdKby+IjXBFsi2RGxfRbnrnTFv1xltUC4ljposNxP0zoLCavrmvD/U+ts7N39Y
         Mg2WyAebEctMEXgsbIK8F5BuVXiM/P4DVt9EgGOyON3H90vHpV3iWO/rRVjF/NEV7Tdk
         TGJW2DO1PMxKVO54DXFknrsvaH8usosUD6DLTl4/AyiNaWzV3g4jgInGaoHpBCozt3cd
         9B8Sfp2RR1sgdmTSmTllDOLRrY+6VvNxSILF3w6DBdjjZ75IYtgxnQ3GWfBmGQ1lUtHg
         RKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686770522; x=1689362522;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i/rLVEpofQ0Syv4PvfDPAbW4A331iFXceGCzfBsi28U=;
        b=j5vX26H6eZgYbxxhWyoJYDQYWrAzNxc3lG/srtJYYTfLyaCgptvuYiGxx4UP8LtfTb
         tXZXowqs6G4HnkArWBkPUapk+iTUXyscOj1XplDMDaR75+mBgVhJD6r6MSPKk+lJsPXY
         Go4Tfh3ECw8FqWgHo/AXcK7NqdMuCd9LR9x3Qe5q3uQppXOXSlTjdp/DNt6NGC7tILUK
         QOeyCUSBt9Ph5Ycmsrzpnz5gNcG9sJBXT6cs/YePstHJJUg3++FDYCBkYnu3mNNOQNGR
         yyCrrrFGTnQltnY+uVDtYHsxF8zCzo0hzK2c8/kv0TjTmtEZSRC8OFwsUEhmxvYuz0X5
         Z9/w==
X-Gm-Message-State: AC+VfDyLJZGoMnlAW8MbqsyajCbh2g00P8ry++1lvF13/X+T7qzf2X+U
	fsVQjDul1wW74/lpJkl9CbOGxT5gPzk=
X-Google-Smtp-Source: ACHHUZ4XL4je8bVAYp8sAYeHVrXp2XZS1qxkvwKba+fbhBkdCi0K0movi/2XR1PLhVUYWMzlpC7tHAxehGk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4501:0:b0:56d:21a1:16a1 with SMTP id
 s1-20020a814501000000b0056d21a116a1mr1209862ywa.5.1686770522234; Wed, 14 Jun
 2023 12:22:02 -0700 (PDT)
Date: Wed, 14 Jun 2023 12:22:00 -0700
In-Reply-To: <20230602161921.208564-7-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-7-amoorthy@google.com>
Message-ID: <ZIoTWOmM2a3iVDAi@google.com>
Subject: Re: [PATCH v4 06/16] KVM: Annotate -EFAULTs from kvm_vcpu_read_guest_page()
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 02, 2023, Anish Moorthy wrote:
> Implement KVM_CAP_MEMORY_FAULT_INFO for uaccess failures within
> kvm_vcpu_read_guest_page().

Same comments as the "write" patch.  And while I often advocate for tiny patches,
I see no reason to split the read and write changes into separate patches, they're
thematically identical enough to count as a "single logical change".
