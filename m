Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F18C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 28 Dec 2021 09:37:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46B1D49E39;
	Tue, 28 Dec 2021 04:37:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ryPhJXjWOLhU; Tue, 28 Dec 2021 04:37:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04DBF49E42;
	Tue, 28 Dec 2021 04:37:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F366649E17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 04:37:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NplkTfN-s-HC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Dec 2021 04:37:18 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9DA649B13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 04:37:18 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1640684238;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=AYLIplJ3WjgSI8SbwSsxJ350FVB/5lVENewKIQD7sgA=;
 b=JWyl0V/XB/uLN3wX2HNw+nC64SmZPDVhM2jJF8zcN9q5JqVlu03WS8PEhMXSK3RENz37E3
 QTKEYT9M81G2qU7dpl5CKQBc1//b7L327C+Q45QDD3xRurbg+6vE5iFWaxvg7eSsJgSxDi
 Itc/g6qEOthWNghBhBLzjHorsF0MkSk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-VONh7KdfOzqyqiL3cnJ_oQ-1; Tue, 28 Dec 2021 04:37:17 -0500
X-MC-Unique: VONh7KdfOzqyqiL3cnJ_oQ-1
Received: by mail-ed1-f72.google.com with SMTP id
 s7-20020a056402520700b003f841380832so12773726edd.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Dec 2021 01:37:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=AYLIplJ3WjgSI8SbwSsxJ350FVB/5lVENewKIQD7sgA=;
 b=3IbgM6ZVtggcLXk0jiz+k9KQMLjfXQmoZFpJra32S+wV4G14PfL47RznAka9N0vi4G
 K2S7j5oJzj1+hP7/tX3pDlPghe11KxSsBDXyxLUvdqsPnED7A41zWmtIwj/FAXEgCDW1
 FAey9rxHzue9xn71gu5onCvFrV8DnZtzCI3VOlSmWI9RjEMn4q7WrDlwy8uHXG1oTuED
 IIo4MaGaMMHnuuiGTvsPK6RnpycsBKO5ECBpHS+8Qwfhj8XKopp0XBGImkFLQnQakF36
 yJfyejCeNIlRai3MMC/uK9b2T4+73e5QGLo+LeGg9v1mj78wvjW7LRwH1tFRy7ZYBsfh
 3GZg==
X-Gm-Message-State: AOAM53187QuqswOQ33tTOLCOs9fdb8Hpc3qdT9cakTJ+oWAUrbFyS030
 Z6GbMwKm5MchtmccpyzrViL8JRBTaoIX/q5FqeVc+mUw+zcy1xiZcTMYPGtvw6N7nw5xq7VKW6f
 VNpK90TAKyJefyWofP9TKe4lE
X-Received: by 2002:a17:907:9493:: with SMTP id
 dm19mr16506703ejc.161.1640684235977; 
 Tue, 28 Dec 2021 01:37:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzn/IYvjgtKdfByEeqLamctbBePIR3Zp/W7Yd+MA4ywG47nuGYWfeA0m+aOzjm3+NNCTMN9og==
X-Received: by 2002:a17:907:9493:: with SMTP id
 dm19mr16506692ejc.161.1640684235840; 
 Tue, 28 Dec 2021 01:37:15 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id qf22sm5908178ejc.85.2021.12.28.01.37.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Dec 2021 01:37:15 -0800 (PST)
Date: Tue, 28 Dec 2021 10:37:13 +0100
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 1/6] KVM: selftests: arm64: Initialise default guest
 mode at test startup time
Message-ID: <20211228093713.moolqqxijvtt5gj7@gator.home>
References: <20211227124809.1335409-1-maz@kernel.org>
 <20211227124809.1335409-2-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211227124809.1335409-2-maz@kernel.org>
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

On Mon, Dec 27, 2021 at 12:48:04PM +0000, Marc Zyngier wrote:
> As we are going to add support for a variable default mode on arm64,
> let's make sure it is setup first by using a constructor that gets
> called before the actual test runs.
> 
> Suggested-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  tools/testing/selftests/kvm/lib/aarch64/processor.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index b4eeeafd2a70..b509341b8411 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -432,3 +432,12 @@ uint32_t guest_get_vcpuid(void)
>  {
>  	return read_sysreg(tpidr_el1);
>  }
> +
> +/*
> + * arm64 doesn't have a true default mode, so start by computing the
> + * available IPA space and page sizes early.
> + */
> +void __attribute__((constructor)) init_guest_modes(void)
> +{
> +       guest_modes_append_default();
> +}
> -- 
> 2.30.2
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
