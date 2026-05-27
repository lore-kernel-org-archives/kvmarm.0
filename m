Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E51B33E358
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 06:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779863391; cv=none; b=jcomfMXQf+QIZu1Vu4Tuwp9EqAgERf4Gj+DythO69onESqa1/lpdEhMza6l/++w/6WBziKxPfQhaD53lrpkxu2kkdX0QpPBhsH9MUpJ7/pg+sFyTub1+oTSLNd2v8vDw5YioFwGgFCrSdXSOBDqFbausNS6TixdtntN6VHyfRTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779863391; c=relaxed/simple;
	bh=4ovKbR2moNt/OhhE65tu6RDTFVc1F9ZJh/c/ItlO8BA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=PUn6AIY9dloVokPma6jFBajFSCkkI9vwP+SW4KLvK1ZTwXE9elc8iEWUrwj/isTPW7OO+Jm4cwbv7o1mHohaDVmIYvvRWlM/zQEm8dbuD+yZe0yN0vV/hD+L+LeE3h+qMVr6v5hqg/AXRIv0+1jHOgOSCl1UZrZTwUBoH7x0RdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D4pHWbx1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D4pHWbx1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779863389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JExJPPFLzVkYK23Ymb0qqNKDhD/YOhK6O4Mtx8xPHYI=;
	b=D4pHWbx1/eRPxNk+xE2V+YPjd6FMRKzjg5HNMlKtF2BKzdEDBJYlB0QpcN3oEvRpGI/GGe
	FLJa5huS0pCltt/u0fLt6jZEUnTASTdfIgFByAQQSh2ZucK7BOYqRVbd6+7fkoj+Ybq9O5
	1mDc5W9d/bCe90vbXcWm5NoE1Xj2kCE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-523-Re-bhR34MlCYzu7ffPUVJQ-1; Wed, 27 May 2026 02:29:47 -0400
X-MC-Unique: Re-bhR34MlCYzu7ffPUVJQ-1
X-Mimecast-MFC-AGG-ID: Re-bhR34MlCYzu7ffPUVJQ_1779863386
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4411a36715dso7468231f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 23:29:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779863386; x=1780468186;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JExJPPFLzVkYK23Ymb0qqNKDhD/YOhK6O4Mtx8xPHYI=;
        b=gL4zNxEPljLBWYrsmzLmoJxDZM+vLlpwt6J3kQvrR2BYh+1qXqpeP4annvutq4JviU
         IpgfAH1vYDLsi2CbFBuqBZOBy3PUZq6MfHqfZol/gtyZF7GbinqBCRRzSnhPh2QyPhZ9
         GjoGifaIVBdFjV5CErR+GiSRGdfTlbZMqpGcoXtJZhXpDZ3wyAcEc1JCw4hKkBW0T4MG
         JFVzFWA8mpquW0HwqnXMGiQH0SDvn48wN7dzbEY2B2C4ikx2/2gVPiZ1UiXxQA8u6Snp
         ns/+9ZIJIh1Z/eqRSUbbG8p8nH+2ix+6cUt/6BTVMHaPlc3P2NcSiWdHfUZbLeCEnsZj
         Z/xA==
X-Forwarded-Encrypted: i=1; AFNElJ8PFfMA5JymTxcjsrzv4oJzxt+kayyEYNrZ9tVXlSwo9HvlF/K4LnrKHguYflXmONODjMdi3LU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+E7OwXv9TB5jmSczA9dds60MZDyIthphlGdqF9qGRbVQamD92
	e+oplZH735Fi7AyWntvmvRoKn+JszMMdHlMVhrx/fn+DxyFql9xYlY895BTsQ/il5YZ/FdS+cae
	tJzNRwGtNX+puknUMyTXm/Swf3tkHywuQL2M3DMmivByWGuzvt9o2VBYEWw==
X-Gm-Gg: Acq92OEqWJazujSp2QunPoLnaXipLaNcNVYNJ3Puqpov6zlc0nV8SeraG9h4nF2MMMX
	qrCieotPggZSWs/m3tV3+h/RE6SBaI9m1TQW7xQCGiuh6XnSVvPcfzzXqh+i5gcpMLW7Ta5TDkA
	7MOyeTlsOJ3halIYxK93P6Hzqzv0wxlqc1zDikh+nAacb4IAqPVXrVaX2GkOcHrbxQh/86TD+jw
	DPpm16vrqo7wzzF3si2/X+paUt2zEfpfee9FYjmhT8xufCvK/GW7/iaEVpfP+TyZ9IUduSWdJ3x
	iX6CQXB/yJbhSxuLBMn8lPMoDanfVke+aNBlAMBBbX8dE43pNjQXEGsKR/R9q4Nl26zDb0VzfUz
	9kNvvdf6UAD3bRp77hl7TUB9Y8eyJP/uxIL3oHPcHuTpYtsQV15WsUUQlrgW8p2i30o7wmOY=
X-Received: by 2002:a05:6000:1447:b0:452:d03a:7abe with SMTP id ffacd0b85a97d-45eb38b91c3mr38816079f8f.17.1779863386138;
        Tue, 26 May 2026 23:29:46 -0700 (PDT)
X-Received: by 2002:a05:6000:1447:b0:452:d03a:7abe with SMTP id ffacd0b85a97d-45eb38b91c3mr38816017f8f.17.1779863385730;
        Tue, 26 May 2026 23:29:45 -0700 (PDT)
Received: from rh (p200300f6af2a6100f239e076bbd76784.dip0.t-ipconnect.de. [2003:f6:af2a:6100:f239:e076:bbd7:6784])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45edb54959bsm4149286f8f.1.2026.05.26.23.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 23:29:45 -0700 (PDT)
Date: Wed, 27 May 2026 08:29:44 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, 
    kvmarm@lists.linux.dev, peter.maydell@linaro.org, 
    shaju.abraham@nutanix.com, khushit.shah@nutanix.com, 
    yangjinqian1@huawei.com, cohuck@redhat.com, richard.henderson@linaro.org, 
    skolothumtho@nvidia.com, philmd@linaro.org, maz@kernel.org, 
    oliver.upton@linux.dev, pbonzini@redhat.com, armbru@redhat.com, 
    berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Subject: Re: [PATCH v5 17/18] arm-qmp-cmds: introspection for ID register
 props
In-Reply-To: <20260519132905.145643-18-eric.auger@redhat.com>
Message-ID: <10ae56f5-6fc7-fe58-1e17-7c3b968045be@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com> <20260519132905.145643-18-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Z-29S5OAhehawfcWuqE-oHk4G4k24q87r_Ym6HG2sJo_1779863386
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

On Tue, 19 May 2026, Eric Auger wrote:
> From: Cornelia Huck <cohuck@redhat.com>
>
> Implement the capability to query available ID register values by
> adding SYSREG_* options and values to the cpu model expansion for the
> host model, if available.
>
> Excerpt:
> (QEMU) query-cpu-model-expansion type=full model={"name":"host"}
> {"return": {"model": {"name": "host", "props":
> {"SYSREG_ID_AA64PFR0_EL1_EL3": 1224979098931106066,
 				 ^
This looks wrong - more like the full reg value and not just EL3..

> "SYSREG_ID_AA64ISAR2_EL1_CLRBHB": 0,
> ../..
>
> So this allows the upper stack to detect available writable ID
> regs and the "host passthrough model" values.
>
> [CH: moved SYSREG_* values to host model]
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

