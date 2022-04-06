Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63B61C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  6 Apr 2022 17:59:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B00C949EF8;
	Wed,  6 Apr 2022 13:59:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9ktKIAV+zdBC; Wed,  6 Apr 2022 13:59:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C22D49EBA;
	Wed,  6 Apr 2022 13:59:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C86CC49E20
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 13:59:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zgoz9djslRtz for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2022 13:59:07 -0400 (EDT)
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com
 [209.85.166.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C71D649E1A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 13:59:07 -0400 (EDT)
Received: by mail-io1-f45.google.com with SMTP id h63so3857028iof.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Apr 2022 10:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=uzEOiJ6yDVmM4HwbN1L4uOpeHV1JQRyCSJYZVvMlr1o=;
 b=motzZ0l4IuCGRfjFIbn/j/l6b/79dg82LGotCDSKTUlBOlU79sQkFVQlJY/zgNuuGO
 qrc6E+V7IDoo1WNAtR9oz02dK3FVRHsx6cwF+L0lbfMjdJbKqLzRmKJQQOFZ/18+f9Wv
 ywS3sVrMYOheluSEb1K9sTiCJQi1PCOVm+iFMXiGqwXKzB1W57TZgXccUUBHE71bGQif
 aJFn1HhosoMK2BV6YkjK9rprCz8cEHwbJgky7RalXATFkXLSHLjc4fG7u3xTBzdIurXC
 kyyZrWzB34DR1pRnhgCsaopxNoUTmGkQ6d0llq+91D1FtRqZAS+HSJMP4ZQUhGkhYe1h
 MRRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=uzEOiJ6yDVmM4HwbN1L4uOpeHV1JQRyCSJYZVvMlr1o=;
 b=6Ig2R8F/ytpw73X7Q0v4gn6LrICdhWYwumL3bfF0d5CaqacjU5gIDpb6POHuE8eqOb
 361ZBLwQfS4dWJOhUlywIHfHrnTPTUjWkdoSjoeoA4fevxceP0bIF5gI5F5JvzgyuEOw
 cEFjPTFpE1QY+zuZDykbUsjw5zsLGlxL1PZM3xiJKjbucDxYefgYCHDevI2zyR1U1g1/
 nvdPMlYC3UwWdEuN55/v+MbSonE7WW/6xYaSI6F1tn/C7HONiRtzanBIjqdAFHhAXZVh
 5L9Z4oqochlGzAh02624ggXCzfJBpagcdTeXDXFaAnmq6nmnzUN8iud9GkMLacVdu6H6
 j1wg==
X-Gm-Message-State: AOAM533Xhu0bIOnQebHZ1kuofL7Agqs+3porst27DWaDW9S+k4LAaFbj
 W+yur4ESFIvUqeDhuwlYCq/HbQ==
X-Google-Smtp-Source: ABdhPJxLKN+3WYbccJPvru/x2ek/ZrRCnqaiXkp6CDMNszfPgh1LY5ykqVNoCgkQNqIn3Xt1jtTcLA==
X-Received: by 2002:a5e:c702:0:b0:64d:1640:9f8c with SMTP id
 f2-20020a5ec702000000b0064d16409f8cmr180542iop.176.1649267946850; 
 Wed, 06 Apr 2022 10:59:06 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 t8-20020a056e02010800b002ca36a382c5sm6339873ilm.52.2022.04.06.10.59.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 06 Apr 2022 10:59:06 -0700 (PDT)
Date: Wed, 6 Apr 2022 17:59:02 +0000
From: Oliver Upton <oupton@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 1/3] KVM: Don't create VM debugfs files outside of the
 VM directory
Message-ID: <Yk3U5tfqBQBOeSs+@google.com>
References: <20220404182119.3561025-1-oupton@google.com>
 <20220404182119.3561025-2-oupton@google.com>
 <87fsmqvgaf.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87fsmqvgaf.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>, stable@kernel.org,
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

On Wed, Apr 06, 2022 at 08:10:00AM +0100, Marc Zyngier wrote:
> Hi Oliver,
> 
> On Mon, 04 Apr 2022 19:21:17 +0100,
> Oliver Upton <oupton@google.com> wrote:
> > 
> > Unfortunately, there is no guarantee that KVM was able to instantiate a
> > debugfs directory for a particular VM. To that end, KVM shouldn't even
> > attempt to create new debugfs files in this case. If the specified
> > parent dentry is NULL, debugfs_create_file() will instantiate files at
> > the root of debugfs.
> > 
> > For arm64, it is possible to create the vgic-state file outside of a
> > VM directory, the file is not cleaned up when a VM is destroyed.
> > Nonetheless, the corresponding struct kvm is freed when the VM is
> > destroyed.
> > 
> > Nip the problem in the bud for all possible errant debugfs file
> > creations by initializing kvm->debugfs_dentry to -ENOENT. In so doing,
> > debugfs_create_file() will fail instead of creating the file in the root
> > directory.
> > 
> > Cc: stable@kernel.org
> > Fixes: 929f45e32499 ("kvm: no need to check return value of debugfs_create functions")
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  virt/kvm/kvm_main.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 70e05af5ebea..04a426e65cb8 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -932,7 +932,7 @@ static void kvm_destroy_vm_debugfs(struct kvm *kvm)
> >  	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
> >  				      kvm_vcpu_stats_header.num_desc;
> >  
> > -	if (!kvm->debugfs_dentry)
> > +	if (!IS_ERR(kvm->debugfs_dentry))
> >  		return;
> 
> Shouldn't this condition be inverted? It certainly looks odd.

Err... Yep, this is plain wrong. Let me fix this obvious mistake.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
