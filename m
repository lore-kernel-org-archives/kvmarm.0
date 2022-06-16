Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAEF3C43334
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jun 2022 18:05:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8166543482;
	Thu, 16 Jun 2022 14:05:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2WTrgQxa-zky; Thu, 16 Jun 2022 14:05:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82E7E49EE9;
	Thu, 16 Jun 2022 14:05:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BCF143482
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 14:05:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G71iwKtrXlyF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jun 2022 14:05:14 -0400 (EDT)
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com
 [209.85.210.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 28FF243399
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 14:05:14 -0400 (EDT)
Received: by mail-pf1-f182.google.com with SMTP id 187so2137913pfu.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jun 2022 11:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=AFEyk3br0FmY0rM/k22+knnd84H9/6UyLVs1yQqOmsI=;
 b=BpuVx4OB7bipxxww8pPuELFOuZ/FTXJuPqc4ZbgvYEECyo2FzpiPuVOfnumF/52T9i
 00eszt60moz3Je5hA20LOszZC8bWYzlbGPXD/XHUjiLPPEUei7o3W66M6covw8XGtr+e
 cHJaY0a5FQf94b1LVv8BvKfcUkZlUyt7SE2BApLMg8CFszsJZag5g1Ngz34nZGaIVbyh
 C6+2m4stG99zKti55uKQjhftSJYv18+cZ7LiY1assrgFJPWlpzw+0FNTPHDBCWbOCGsC
 d6bZ5qj930404y4jdkrtQJdXkc4Neypw8xU8u+ocwBpkFGGeuL7bXE9rWtcsWdQbBKw1
 Eu0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=AFEyk3br0FmY0rM/k22+knnd84H9/6UyLVs1yQqOmsI=;
 b=MHZSc4+gdopBXu2dUA1eLx1mXs+O2Xv+hbmQD1vKg3bwcpqJqgn2nQTeDJl8KpzGlH
 eYcsiGhkzW8uregcPacw4Qe8PFpfHwr9XE/181nxFQbKnK/zT/Qb1wmKCB8zgeTSZwSJ
 xv/EJKU9lHR6Bn1MQwSZZJPp8x2RGRZrja8b1gjHViDywTn6OmGjkdnQzAvV2wFBEYUH
 rQTioy9846Bf7FQUaqDry+mvBqPc1lj7yOPk8bmU1Njx9JS50vUu57Fdr3rK2d4JliLa
 YDUuCgBqN2TlyxlOJsP+bDFZHISarNcRtDNzpHWwU8Av7pfRdVWCGEpcw0FRYrdcRNYi
 rjGw==
X-Gm-Message-State: AJIora9EvwzBMx5/oftPKrfgRoCVjLLS71Nge8BwBREDv3an2b4694sy
 Rei9JQRBGZjbFImuwUPv/JDsBQ==
X-Google-Smtp-Source: AGRyM1vwByP5SE3HSqJJxXVfuu2sUqko6W26PPM6hUp+T+x7wR6sg6mgEZFTF3V/SjfjtZMiV0FJ8A==
X-Received: by 2002:aa7:9728:0:b0:51b:e78e:b333 with SMTP id
 k8-20020aa79728000000b0051be78eb333mr5890627pfg.36.1655402712991; 
 Thu, 16 Jun 2022 11:05:12 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 y1-20020a63ad41000000b003fae8a7e3e5sm2064426pgo.91.2022.06.16.11.05.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Jun 2022 11:05:12 -0700 (PDT)
Date: Thu, 16 Jun 2022 18:05:08 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 5/5] KVM: Hoist debugfs_dentry init to
 kvm_create_vm_debugfs() (again)
Message-ID: <Yqtw1PqSlisZO+jU@google.com>
References: <20220518175811.2758661-1-oupton@google.com>
 <20220518175811.2758661-6-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220518175811.2758661-6-oupton@google.com>
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 maz@kernel.org
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

On Wed, May 18, 2022, Oliver Upton wrote:
> Since KVM now sanely handles debugfs init/destroy w.r.t. the VM, it is
> safe to hoist kvm_create_vm_debugfs() back into kvm_create_vm(). The
> author of this commit remains bitter for having been burned by the old
> wreck in commit a44a4cc1c969 ("KVM: Don't create VM debugfs files
> outside of the VM directory").
> 
> Signed-off-by: Oliver Upton <oupton@google.com>

Heh, with the above changelog, shouldn't this be?  :-)

  Signed-off-by: Oliver "Works on my Machine" Upton <oupton@google.com>

Reviewed-by: Sean Christopherson <seanjc@google.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
