Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2FC8C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 18:13:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1CE1B61247
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 18:13:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1CE1B61247
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65A3E4B2A1;
	Mon,  4 Oct 2021 14:13:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mu4bKtmuDZrN; Mon,  4 Oct 2021 14:13:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 822C64B2A5;
	Mon,  4 Oct 2021 14:13:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEAAD4B252
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 14:13:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 106aZNYUjWeo for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 14:13:40 -0400 (EDT)
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com
 [209.85.167.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C61B24B29E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 14:13:40 -0400 (EDT)
Received: by mail-oi1-f171.google.com with SMTP id v10so22725336oic.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 11:13:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=7MmG9UNeaN9rX2Xe0UpnHbblcz68hViXX139qRa5xqs=;
 b=VPDZPLLIapdnctCEZWricxqBLfeIFjWBm+lukVyu4+t5tDlYDY61Dmp05cAef0glhQ
 IvLTnF8QwsNV2DnAhmxTpuUrFfcOMfVOafaOhCj4eciMR062IMUzGYAT7opWjmSeCWvn
 nDi2aQn+brzNOaaurtbqz2zunwlge6bC6LZq+GOGa0S/Hnt8gK/Xu8NvSpRVkSakfqYr
 wSjwU7j3AZih15ox56TNOcI1k/FgR36BkcaEFrRqPLFtOmHfUXYytu5+LK7SiEFy4zkq
 Li9GY02q4R3htSZv0IxQbJy7CpL4BUwhaDHnyxI6Wrcn9D5GvGzSSeG0SNri+H5u3bll
 STUg==
X-Gm-Message-State: AOAM530Tbuiza3g1ALoG7F2YnSU3MwrE9G/48CPYsfoLLEyz2/w+pAv0
 NNImnTu5m+jFua3TQN4zJg==
X-Google-Smtp-Source: ABdhPJx0ioUdg1qmUioj/6ORoTI6fqApCcPadwhZIZ/aH8TQKsWdiLD5MArO3D+E2krV4WhpTIUqEA==
X-Received: by 2002:aca:1b09:: with SMTP id b9mr14672812oib.55.1633371220108; 
 Mon, 04 Oct 2021 11:13:40 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net.
 [66.90.148.213])
 by smtp.gmail.com with ESMTPSA id d7sm2973690ooa.36.2021.10.04.11.13.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Oct 2021 11:13:39 -0700 (PDT)
Received: (nullmailer pid 1588507 invoked by uid 1000);
 Mon, 04 Oct 2021 18:13:38 -0000
Date: Mon, 4 Oct 2021 13:13:38 -0500
From: Rob Herring <robh@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v2 1/2] Documentation, dt, numa: Add note to empty NUMA
 node
Message-ID: <YVtEUpIFdOrIoH0B@robh.at.kernel.org>
References: <20210927064119.127285-1-gshan@redhat.com>
 <20210927064119.127285-2-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210927064119.127285-2-gshan@redhat.com>
Cc: devicetree@vger.kernel.org, linux-efi@vger.kernel.org, maz@kernel.org,
 rdunlap@infradead.org, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Mon, 27 Sep 2021 14:41:18 +0800, Gavin Shan wrote:
> The empty memory nodes, where no memory resides in, are allowed.
> The NUMA node IDs are still valid and parsed, but memory may be
> added to them through hotplug afterwards. Currently, QEMU fails
> to boot when multiple empty memory nodes are specified. It's
> caused by device-tree population failure and duplicated memory
> node names.
> 
> The device-tree specification doesn't provide how empty NUMA
> nodes are handled. Besides, I finds difficulty to get where
> this case is documented. So lets add a section for empty memory
> nodes to cover it in NUMA binding document.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  Documentation/devicetree/bindings/numa.txt | 46 +++++++++++++++++++++-
>  1 file changed, 45 insertions(+), 1 deletion(-)
> 

Applied, thanks!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
