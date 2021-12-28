Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B47DFC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 28 Dec 2021 09:26:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D484749EEB;
	Tue, 28 Dec 2021 04:26:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tbzck7OH98CO; Tue, 28 Dec 2021 04:26:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A510A49EDE;
	Tue, 28 Dec 2021 04:26:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08EF049ED7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 04:26:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BIuhbAdG-OZm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Dec 2021 04:26:27 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E398E49EBD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 04:26:27 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1640683587;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ieouWQmKcK4lsX86c5cvIrP3JO2ETy1mOZd2ZiHvYjA=;
 b=Wd+joaldWLtP+nSqdHmMET2AFJ62+JEFw9rMIhQSzEGBf4nIS21h/l9I2rOOESW972Ayp2
 OfycpjFE13q20TAub5f9UXfvIdE6N0z8t+FxSC4Df4hx2O/Y160uGS5m7vUtu57DjlCOA/
 97uohexkFyDmHiKOeFdCnrY5HhEzGRw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-Q_DBVIKnPB-h1je16yiSaA-1; Tue, 28 Dec 2021 04:26:26 -0500
X-MC-Unique: Q_DBVIKnPB-h1je16yiSaA-1
Received: by mail-ed1-f69.google.com with SMTP id
 dm10-20020a05640222ca00b003f808b5aa18so12762729edb.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 01:26:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ieouWQmKcK4lsX86c5cvIrP3JO2ETy1mOZd2ZiHvYjA=;
 b=yqmbf5JO8X7tMXRZEi3KeXkKq3pXcwUA79yB0JRMaa9RSANIXRRoOju7LDKdSIX5Ue
 d51tVj6qeQgL3XwvJF6KCJPiLRpmzBUudRM1Nrp42h/UW7biV45MrpVuIch0GE8Y4UOM
 RXDOTP2URoJbEHY2ZRnn2JJAj+tZg54Lrj5/24T0RfJ04A0y0otaUeqsxvfSDOPZGNba
 qpSyyV/PKMx0bdZs3rrMLjSS+jO4F8RtKbKiB+UolOa/xUaXPpKh+eYqraQS8su4ZXWy
 0RYBI9QYYZyRMkjj9AIkLqdp2AZqo7KS/YlTpFpQ9Ggn3uHWp7RSBiy8g5xJUveBOl8I
 hohA==
X-Gm-Message-State: AOAM531/W2kwYof9xqISAivzYxg3jfF3vJQ+o5nq1N1MSb/VLa2VY6aJ
 QOeVnYCAecuS3gUBjohweXZjWFCL9gskIoD+fongEvuxiYHw8LSv+jeZb3LtYBFZZjCEqK534qm
 uR0XFeqI2u/linDefPYXwhkfD
X-Received: by 2002:a17:907:6d04:: with SMTP id
 sa4mr17742294ejc.526.1640683584994; 
 Tue, 28 Dec 2021 01:26:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxmlaMBdkRJbLGn5nXSbPpENZRP59VGli32Sc48JzqYm4bDG7UjXAyQtXLu3H1XqrBhKJO6Ew==
X-Received: by 2002:a17:907:6d04:: with SMTP id
 sa4mr17742283ejc.526.1640683584825; 
 Tue, 28 Dec 2021 01:26:24 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id b7sm7153565edj.24.2021.12.28.01.26.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Dec 2021 01:26:24 -0800 (PST)
Date: Tue, 28 Dec 2021 10:26:22 +0100
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 2/6] KVM: selftests: arm64: Introduce a variable
 default IPA size
Message-ID: <20211228092622.ffw7xu2j5ow4njxo@gator.home>
References: <20211227124809.1335409-1-maz@kernel.org>
 <20211227124809.1335409-3-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211227124809.1335409-3-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, kernel-team@android.com,
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

On Mon, Dec 27, 2021 at 12:48:05PM +0000, Marc Zyngier wrote:
> Contrary to popular belief, there is no such thing as a default
> IPA size on arm64. Anything goes, and implementations are the
> usual Wild West.
> 
> The selftest infrastructure default to 40bit IPA, which obviously
> doesn't work for some systems out there.
> 
> Turn VM_MODE_DEFAULT from a constant into a variable, and let
> guest_modes_append_default() populate it, depending on what
> the HW can do. In order to preserve the current behaviour, we
> still pick 40bits IPA as the default if it is available, and
> the largest supported IPA space otherwise.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  |  4 ++-
>  tools/testing/selftests/kvm/lib/guest_modes.c | 30 +++++++++++++++++--
>  2 files changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 2d62edc49d67..7fa0a93d7526 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -53,7 +53,9 @@ enum vm_guest_mode {
>  
>  #if defined(__aarch64__)
>  
> -#define VM_MODE_DEFAULT			VM_MODE_P40V48_4K
> +extern enum vm_guest_mode vm_mode_default;
> +
> +#define VM_MODE_DEFAULT			vm_mode_default
>  #define MIN_PAGE_SHIFT			12U
>  #define ptes_per_page(page_size)	((page_size) / 8)
>  
> diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
> index c330f414ef96..5e3fdbd992fd 100644
> --- a/tools/testing/selftests/kvm/lib/guest_modes.c
> +++ b/tools/testing/selftests/kvm/lib/guest_modes.c
> @@ -4,22 +4,46 @@
>   */
>  #include "guest_modes.h"
>  
> +#ifdef __aarch64__
> +enum vm_guest_mode vm_mode_default;
> +#endif
> +
>  struct guest_mode guest_modes[NUM_VM_MODES];
>  
>  void guest_modes_append_default(void)
>  {
> +#ifndef __aarch64__
>  	guest_mode_append(VM_MODE_DEFAULT, true, true);
> -
> -#ifdef __aarch64__
> -	guest_mode_append(VM_MODE_P40V48_64K, true, true);
> +#else
>  	{
>  		unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
> +		int i;
> +
> +		vm_mode_default = NUM_VM_MODES;
> +
>  		if (limit >= 52)
>  			guest_mode_append(VM_MODE_P52V48_64K, true, true);
>  		if (limit >= 48) {
>  			guest_mode_append(VM_MODE_P48V48_4K, true, true);
>  			guest_mode_append(VM_MODE_P48V48_64K, true, true);
>  		}
> +		if (limit >= 40) {
> +			guest_mode_append(VM_MODE_P40V48_4K, true, true);
> +			guest_mode_append(VM_MODE_P40V48_64K, true, true);
> +			vm_mode_default = VM_MODE_P40V48_4K;
> +		}
> +
> +		/*
> +		 * Pick the first supported IPA size if the default
> +		 * isn't available.
> +		 */
> +		for (i = 0; vm_mode_default == NUM_VM_MODES && i < NUM_VM_MODES; i++) {
> +			if (guest_modes[i].supported && guest_modes[i].enabled)
> +				vm_mode_default = i;

Since we don't have a 'break' here, this picks the last supported size
(of the guest_modes list), not the first, as the comment implies it should
do.

Thanks,
drew

> +		}
> +
> +		TEST_ASSERT(vm_mode_default != NUM_VM_MODES,
> +			    "No supported mode!");
>  	}
>  #endif
>  #ifdef __s390x__
> -- 
> 2.30.2
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
