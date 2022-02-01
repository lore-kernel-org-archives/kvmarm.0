Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 002A8C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  1 Feb 2022 14:44:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 742F949F2C;
	Tue,  1 Feb 2022 09:44:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KS420KCsJBpN; Tue,  1 Feb 2022 09:44:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67D7649F07;
	Tue,  1 Feb 2022 09:44:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C106349EF0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 09:44:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id phMXzoP6W8KD for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Feb 2022 09:44:42 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADF6B49E2C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 09:44:42 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1643726682;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=xPr60qxZCyURf1wWnO6jqTyKtFPYAeP8pg9MJVVWY5E=;
 b=i+HAYH5ch+qg91aKEEuUk3TLTK2yBB9IihnJX2d0FkUHD8bhxBumH9xSGRzF03LZZFqKxN
 YqHuw+q3a39u78G6D5l6d8bVIiFCcblGv0SkhCJFfqD+JsVIw7lev11LwW3uuzFdgVkshr
 Tcjfiow0UgA2q/9EZMES1P9NDVp1hM8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-4Ob5OEDmO8u2NbPpLLvnvA-1; Tue, 01 Feb 2022 09:44:41 -0500
X-MC-Unique: 4Ob5OEDmO8u2NbPpLLvnvA-1
Received: by mail-ej1-f70.google.com with SMTP id
 m4-20020a170906160400b006be3f85906eso747552ejd.23
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Feb 2022 06:44:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=xPr60qxZCyURf1wWnO6jqTyKtFPYAeP8pg9MJVVWY5E=;
 b=chz0qGpjUsDMH1H/NupSxPbqNNqXesnFvLk05yPPdl4/3xJCGZcgQopu1jcx5HypKg
 RuWDVnxk+GK1M4xoCnQQRkhhvUres/RNe/bmEtv/NEyFP+GK+NYPx6QVOC2d1QtUOLYQ
 +wHMhJHUHidvO+SKvduTLQbCPo/Go5cRKrBq3/PVo4Ytii6pOzd/vxKTXQE6dGESCkGZ
 n6exVAd673A5YFyS+9MFXb3WwU8OEmy863Zibk0zCOmldYmVyfEQq4SuxCGT7OYyDQnt
 ooWGwHt3TvSaY6hUquOBp62wjpoidHEoeMjCqOaVVhjKsmKYeCNEg3ovDWsYes6i8ntJ
 eFYQ==
X-Gm-Message-State: AOAM532Bf+KYK/Sz+cg/oP+QWLvBFz2PEymmQfLXZ7HIuohwU3hHqz5F
 Tn9XUGmn9ElkBwzMnLfkVxqNZxq1ggiyDae9PBmu8CxtknOcgbXEVFMn3bkSUuGAfvcyii7CiS8
 aess6Wgob2pkG9ok6x1yqiveU
X-Received: by 2002:a17:906:7945:: with SMTP id
 l5mr21603468ejo.104.1643726680193; 
 Tue, 01 Feb 2022 06:44:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJynyvXIDdrE1MhRE3SomRdqiNaV91tp5hjxrkxBUNOFv2HU89Omp/4lqyWDEBDXFkSRHTwgNA==
X-Received: by 2002:a17:906:7945:: with SMTP id
 l5mr21603437ejo.104.1643726679954; 
 Tue, 01 Feb 2022 06:44:39 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id m13sm14613223eja.160.2022.02.01.06.44.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 01 Feb 2022 06:44:39 -0800 (PST)
Date: Tue, 1 Feb 2022 15:44:37 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [kvm-unit-tests PATCH v3 0/3] GIC ITS tests
Message-ID: <20220201144437.fw5fv7xfxspf7a6s@gator>
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
 <20211112132312.qrgmby55mlenj72p@gator.home>
 <87wnldfoul.fsf@linaro.org>
 <20211112145442.5ktlpwyolwdsxlnx@gator.home>
 <877dd4umy6.fsf@linaro.org>
 <20211119183059.jwrhb77jfjbv5rbz@gator.home>
 <87a6hlzq8t.fsf@linaro.org>
 <20211130143425.bh27yy47vpihllvs@gator.home>
 <87sft2yboq.fsf@linaro.org>
MIME-Version: 1.0
In-Reply-To: <87sft2yboq.fsf@linaro.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, shashi.mallela@linaro.org,
 qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
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

On Tue, Feb 01, 2022 at 01:10:13PM +0000, Alex Benn=E9e wrote:
> =

> Gentle ping, I'm trying to clear this off my internal JIRA so let me
> know if you want me to do anything to help.
>

Sorry Alex! I've been juggling too many balls lately and completely
dropped this one. I'll rebase arm/queue now and run it through some
sanity tests. If all it good, I'll do the MR right away.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
