Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6916AC4338F
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 16:23:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DA29C60EBB
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 16:23:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DA29C60EBB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F9674B0DD;
	Thu, 29 Jul 2021 12:23:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L+D438kYX7kI; Thu, 29 Jul 2021 12:23:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EEB04B0E4;
	Thu, 29 Jul 2021 12:23:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CCB04B0DD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 12:23:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id by78x+FULDWZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 12:23:45 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83B5E4B0D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 12:23:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1627575825;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=8XlvRujXH8fG7I60x6Lze35EmuQmao4vXlcoc/uU2No=;
 b=QL8ASzbEQ/0EvuKR5nZlzza88Hz2k+daAuNwBlPzOHyglc+a0Cn3W/XFrjjZVW+tjhTxT/
 x8oUzMtFBim7l+JdMHQ1zZG1po0MlhOMB/krmq/8Q2pYWR08J/ZkfNrmSZvwBzloXgq1rl
 tIHg7KmH0SYluiI1FSEhLN5nKAbsfn8=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-ROAbDRz9NamzpF2pzV4vyg-1; Thu, 29 Jul 2021 12:22:30 -0400
X-MC-Unique: ROAbDRz9NamzpF2pzV4vyg-1
Received: by mail-il1-f200.google.com with SMTP id
 d9-20020a056e021c49b02902095727d18dso3520723ilg.17
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:22:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=8XlvRujXH8fG7I60x6Lze35EmuQmao4vXlcoc/uU2No=;
 b=ZaPKrVczlqP88yJS75MQU6hfBEmkkUbmWrnX22DQqeIHXuBkbo54qUqH/81c19tbj3
 9W2QCgWuPVBzD6nYK7IbosCmF5Y6qJvRaPmrEgdQkPjXP2YpPTjGxvVzpUNmTtIBB6y7
 ViBs/NmM+XwFWUT3h3/2ExdAxDPfPf+JjE6OvePltCBCn6ipNRxPjX3/ar8Iuuq0h6aX
 VYTsuj7nN1lOxJaijk2TMyLowt+X9ASoPZwrSTSMrnRDt9C9jkkkxqVkJgCZVfB16+YL
 nZGPg2oFy6mpTyi3bLeQhNZX8Ibwt4mrAm/o8BOiFvmvOJVh2Ph2VpJ0HRTeMzZbvo1f
 Qf2A==
X-Gm-Message-State: AOAM531+uQNMPqSkTuplrA53E1H3wbb/pm4+yydNarCAaZkbxwsScTtf
 QZYjCA0ynMpgrYEZt6RtHrurN7KMswtKHG1Icj7shoSheBdDN++2BbGelE1hmdAQnpVKNtixPXf
 nYpzDlb1fDehpWapucByY7Zjg
X-Received: by 2002:a92:d4c4:: with SMTP id o4mr4032655ilm.39.1627575749941;
 Thu, 29 Jul 2021 09:22:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4Fgu9rQ1o/mvPKtWpoTLqejJyf90dyQNVh+Lg+zjo1jBFHEmgfOa/z3eVTuadhwo9KRb6mQ==
X-Received: by 2002:a92:d4c4:: with SMTP id o4mr4032632ilm.39.1627575749732;
 Thu, 29 Jul 2021 09:22:29 -0700 (PDT)
Received: from gator ([140.82.166.162])
 by smtp.gmail.com with ESMTPSA id p1sm1929221ilh.47.2021.07.29.09.22.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 29 Jul 2021 09:22:29 -0700 (PDT)
Date: Thu, 29 Jul 2021 18:22:26 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v4 06/13] selftests: KVM: Fix kvm device helper ioctl
 assertions
Message-ID: <20210729162226.a6csfjpzhhpdgv7o@gator>
References: <20210729001012.70394-1-oupton@google.com>
 <20210729001012.70394-7-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210729001012.70394-7-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Thu, Jul 29, 2021 at 12:10:05AM +0000, Oliver Upton wrote:
> The KVM_CREATE_DEVICE and KVM_{GET,SET}_DEVICE_ATTR ioctls are defined
> to return a value of zero on success. As such, tighten the assertions in
> the helper functions to only pass if the return code is zero.
> 
> Suggested-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 10a8ed691c66..0ffc2d39c80d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1984,7 +1984,7 @@ int kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr)
>  {
>  	int ret = _kvm_device_check_attr(dev_fd, group, attr);
>  
> -	TEST_ASSERT(ret >= 0, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
> +	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
>  	return ret;
>  }
>  
> @@ -2008,7 +2008,7 @@ int kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test)
>  	ret = _kvm_create_device(vm, type, test, &fd);
>  
>  	if (!test) {
> -		TEST_ASSERT(ret >= 0,
> +		TEST_ASSERT(!ret,
>  			    "KVM_CREATE_DEVICE IOCTL failed, rc: %i errno: %i", ret, errno);
>  		return fd;
>  	}
> @@ -2036,7 +2036,7 @@ int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
>  {
>  	int ret = _kvm_device_access(dev_fd, group, attr, val, write);
>  
> -	TEST_ASSERT(ret >= 0, "KVM_SET|GET_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
> +	TEST_ASSERT(!ret, "KVM_SET|GET_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
>  	return ret;
>  }
>  
> -- 
> 2.32.0.432.gabb21c7263-goog
>
 
Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
