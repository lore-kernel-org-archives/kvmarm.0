Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95632C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 24 Nov 2021 16:49:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2275E4B190;
	Wed, 24 Nov 2021 11:49:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7x4H0B25Jvy1; Wed, 24 Nov 2021 11:49:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C60A4B1A0;
	Wed, 24 Nov 2021 11:49:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FBB74B1A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 11:49:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LY8eay2Mruem for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Nov 2021 11:49:06 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25E804B16F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 11:49:06 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637772545;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9J3cD1dyyOWaeZtyt11eMPdAt6Sv3JFpKNvzxQVuJ5s=;
 b=K9QeP0OCk3+AOYbatHQEhveYkVzlHLZ5Hyc6fydEeCe6M+glbQv0GFoTakSTSuSXMsE+6E
 3MrCQI5BQmuOFCwhgNpQ9kA1k/baEVQRd1dJLWQo5ntY85bfgMqSlKiiFLXp8InGyFZHto
 FSZBBx7Xu3EvD8EpSq5NOh3L2K0Es74=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-twNzMOMVNDOmbMAQpBXqDg-1; Wed, 24 Nov 2021 11:49:03 -0500
X-MC-Unique: twNzMOMVNDOmbMAQpBXqDg-1
Received: by mail-wm1-f70.google.com with SMTP id
 g81-20020a1c9d54000000b003330e488323so1945407wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 08:49:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=9J3cD1dyyOWaeZtyt11eMPdAt6Sv3JFpKNvzxQVuJ5s=;
 b=iFd9ZKMnCz1EynN2AuOfNsKtX/E05M3OGRWBY/RWnXbQYqK5oBMaOT65wHk3a9z1BQ
 lcu8mgWyGWcnWLyx1hnMtAFRWvQYGIvI/JtkPNpaV5OL2uWRWD6rJKeqILQ3oRyCdIKV
 Q4JHd0Kw53prFSoCAgLo+HX3AcaveZ9mtN+3+F8DeRCHowqLJ6vI9L9OcBR23HKzDipW
 9qWZdkJRy+i81KcpG4is71xO+nAYi/XkoRnA45+I6VRDltq7vv9j+UO53xof9UDPGBbQ
 rGvucv5/4Dz2CQ4QRBEVrc+19O4oEf8on1e3H6DKc1u0TKXVxlm7CvCNvJS98C5tEhcI
 EkAA==
X-Gm-Message-State: AOAM532/5YgHDkCow7weryT9TsdU20JHVbPK+IjarlXhvOPVO+oAXGIA
 b33wcFtT5FM1oHs6FlzdvYw80GAKEAuAaClm9yCUDne6oVqtF91BDMvEC+5ePOZU0Y2j4RxKTTO
 aQTUIzGSFKgWE9zgi7ZcLncj7
X-Received: by 2002:a05:600c:202:: with SMTP id
 2mr17343021wmi.134.1637772541961; 
 Wed, 24 Nov 2021 08:49:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz8+y4uHEYO0F0AY23C+bnwKrPr+F3pwAPTFQD3xgmryE/REWkJq9qNVUDwYJm7a9a1iDU8BA==
X-Received: by 2002:a05:600c:202:: with SMTP id
 2mr17342972wmi.134.1637772541675; 
 Wed, 24 Nov 2021 08:49:01 -0800 (PST)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id o4sm6354481wmq.31.2021.11.24.08.49.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 24 Nov 2021 08:49:01 -0800 (PST)
Date: Wed, 24 Nov 2021 17:48:59 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v8 04/10] run_tests.sh: add --config
 option for alt test set
Message-ID: <20211124164859.4enqimrptr3pfdkp@gator>
References: <20211118184650.661575-1-alex.bennee@linaro.org>
 <20211118184650.661575-5-alex.bennee@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20211118184650.661575-5-alex.bennee@linaro.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, qemu-arm@nongnu.org,
 idan.horowitz@gmail.com, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Nov 18, 2021 at 06:46:44PM +0000, Alex Benn=E9e wrote:
> The upcoming MTTCG tests don't need to be run for normal KVM unit
> tests so lets add the facility to have a custom set of tests.

I think an environment variable override would be better than this command
line override, because then we could also get mkstandalone to work with
the new unittests.cfg files. Or, it may be better to just add them to
the main unittests.cfg with lines like these

groups =3D nodefault mttcg
accel =3D tcg

That'll "dirty" the logs with SKIP ... (test marked as manual run only)
for each one, but at least we won't easily forget about running them from
time to time.

Thanks,
drew


> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> ---
>  run_tests.sh | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> =

> diff --git a/run_tests.sh b/run_tests.sh
> index 9f233c5..b1088d2 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -15,7 +15,7 @@ function usage()
>  {
>  cat <<EOF
>  =

> -Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t]
> +Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t] [-c CONFIG]
>  =

>      -h, --help      Output this help text
>      -v, --verbose   Enables verbose mode
> @@ -24,6 +24,7 @@ Usage: $0 [-h] [-v] [-a] [-g group] [-j NUM-TASKS] [-t]
>      -g, --group     Only execute tests in the given group
>      -j, --parallel  Execute tests in parallel
>      -t, --tap13     Output test results in TAP format
> +    -c, --config    Override default unittests.cfg
>  =

>  Set the environment variable QEMU=3D/path/to/qemu-system-ARCH to
>  specify the appropriate qemu binary for ARCH-run.
> @@ -42,7 +43,7 @@ if [ $? -ne 4 ]; then
>  fi
>  =

>  only_tests=3D""
> -args=3D$(getopt -u -o ag:htj:v -l all,group:,help,tap13,parallel:,verbos=
e -- $*)
> +args=3D$(getopt -u -o ag:htj:vc: -l all,group:,help,tap13,parallel:,verb=
ose,config: -- $*)
>  [ $? -ne 0 ] && exit 2;
>  set -- $args;
>  while [ $# -gt 0 ]; do
> @@ -73,6 +74,10 @@ while [ $# -gt 0 ]; do
>          -t | --tap13)
>              tap_output=3D"yes"
>              ;;
> +        -c | --config)
> +            shift
> +            config=3D$1
> +            ;;
>          --)
>              ;;
>          *)
> @@ -152,7 +157,7 @@ function run_task()
>  =

>  : ${unittest_log_dir:=3Dlogs}
>  : ${unittest_run_queues:=3D1}
> -config=3D$TEST_DIR/unittests.cfg
> +: ${config:=3D$TEST_DIR/unittests.cfg}
>  =

>  rm -rf $unittest_log_dir.old
>  [ -d $unittest_log_dir ] && mv $unittest_log_dir $unittest_log_dir.old
> -- =

> 2.30.2
> =

> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
