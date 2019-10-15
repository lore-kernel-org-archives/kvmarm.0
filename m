Return-Path: <SRS0=Qc2f=YI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A9CECE59D
	for <kvmarm@archiver.kernel.org>; Tue, 15 Oct 2019 22:35:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 06E5D2067B
	for <kvmarm@archiver.kernel.org>; Tue, 15 Oct 2019 22:35:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TdYZUFJH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 06E5D2067B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 653864A9BA;
	Tue, 15 Oct 2019 18:35:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gOR9wrZaNkAB; Tue, 15 Oct 2019 18:35:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F10C4A9BF;
	Tue, 15 Oct 2019 18:35:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EB704A9BA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Oct 2019 18:35:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3tRIc2MMwHfY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Oct 2019 18:35:24 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B1194A98A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Oct 2019 18:35:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1571178924;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9F2rYjWK9ziFocCIMNfTpax2GOtKztQS4lutNS8gIlc=;
 b=TdYZUFJHhW3E+hoz1mNOtbQGN9m3QYlLjkaMHMLvLbvQjKFEBKGUClfNNArlLRUvXqMoJA
 QfwfJB6gJ/Jn/X4UQqJg2gmv4c1hPjH4nbpky/okjiZOkp0J3bsEeyxNNd/TrJufZ8qQK2
 lf5CpQiFOzf1hgA1pv1JFRvq5NejKEI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-2jSSDoxdM4Gxl5U5PGRD8Q-1; Tue, 15 Oct 2019 18:35:22 -0400
Received: by mail-wr1-f69.google.com with SMTP id f4so7088193wrj.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Oct 2019 15:35:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=Klw9BBs/uRXS08lOiDz40aM4kc+jmIjD/L7OQgU9RpQ=;
 b=TddxB67pDT4rIu7MnHGLTtcXCvobZbxCv9/86SAyi0pxSaAxnsXlGeKnB0STGBT3rk
 iGGCq6zgV7EX5cJl6d1WmbhR/8ihhqwjOzD8bF+6KOH7Uy2+YutbgvS6cVEJH8V2HvDQ
 rqVkGJ8NrTKkBnEE3TaJCuG3F20c/nJzOca1xTvlNzcjZF9G/UMgnZZikCsvGACLfhht
 c8bH/KVOAs3zcFy9fqHQNjUPd9LmDlKrrjuglF8ff4fpkkRlbPb3ka2t1/CENgPgliBj
 LkgB8fenRfE+P8pwFzmBNSIh/LWKHxV0/mzdKMd2kMfp6sqxGI1H2crd9HBwgsHQTblg
 s/QQ==
X-Gm-Message-State: APjAAAVNd3UOJLpqujH7AARwKeUFic/Jc05iI6+xkVvPVhafTna9/h1M
 56RPaFDANZao7y7ZNOMG5lZMAXvYfYwzNWn40cPMKIgty6oRmiEM8gzKqI/mdk/EUYoLWSRWbyz
 PJn9am1DFXEZMt1XZMw1xdWcg
X-Received: by 2002:a1c:7e10:: with SMTP id z16mr548001wmc.11.1571178920975;
 Tue, 15 Oct 2019 15:35:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy1iyLLTiDLs+t2SLsnm7KLC4V/LNTF3V6ZsBtx2m2Wming/W18J0rGV7YsyfVCmmOqtU/SdA==
X-Received: by 2002:a1c:7e10:: with SMTP id z16mr547985wmc.11.1571178920686;
 Tue, 15 Oct 2019 15:35:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e?
 ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
 by smtp.gmail.com with ESMTPSA id y13sm33305655wrg.8.2019.10.15.15.35.19
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 15 Oct 2019 15:35:20 -0700 (PDT)
Subject: Re: [PATCH v5 3/6] timekeeping: Add clocksource to
 system_time_snapshot
To: Thomas Gleixner <tglx@linutronix.de>, Jianyong Wu <jianyong.wu@arm.com>
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-4-jianyong.wu@arm.com>
 <alpine.DEB.2.21.1910152047490.2518@nanos.tec.linutronix.de>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cfa31e7c-83c4-0e16-ff7d-c6d6f0160e98@redhat.com>
Date: Wed, 16 Oct 2019 00:35:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1910152047490.2518@nanos.tec.linutronix.de>
Content-Language: en-US
X-MC-Unique: 2jSSDoxdM4Gxl5U5PGRD8Q-1
X-Mimecast-Spam-Score: 0
Cc: justin.he@arm.com, kvm@vger.kernel.org, maz@kernel.org,
 richardcochran@gmail.com, yangbo.lu@nxp.com, linux-kernel@vger.kernel.org,
 sean.j.christopherson@intel.com, john.stultz@linaro.org,
 netdev@vger.kernel.org, nd@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 15/10/19 22:12, Thomas Gleixner wrote:
> @@ -91,6 +96,7 @@ struct clocksource {
>  	const char *name;
>  	struct list_head list;
>  	int rating;
> +	enum clocksource_ids id;

Why add a global id?  ARM can add it to archdata similar to how x86 has
vclock_mode.  But I still think the right thing to do is to include the
full system_counterval_t in the result of ktime_get_snapshot.  (More in
a second, feel free to reply to the other email only).

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
