Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4988EC433E2
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 11:01:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B078B214F1
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 11:01:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TyMbFj/C"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B078B214F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 456934B44B;
	Thu, 10 Sep 2020 07:01:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tXcxNhPILgPb; Thu, 10 Sep 2020 07:01:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F140A4B478;
	Thu, 10 Sep 2020 07:01:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 19B474B325
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 06:16:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NF1fyGQeTDbq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2020 06:16:38 -0400 (EDT)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 276584B324
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 06:16:38 -0400 (EDT)
Received: by mail-wm1-f66.google.com with SMTP id e17so5065532wme.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 03:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=DqY3ytm1lW24L4dBr5ZhfVe1Kl4JG7b6aElJixa0DtQ=;
 b=TyMbFj/CCKS/yEhzmJyx0SXASPCumWs129eaMWwliNPHoe9nGlJZk2Tsw17ABtL/mL
 mWke72l5dRMmrFg9ieYmDr1jVfXiMwSmIMEMsNuXAYrMDmbRSlu2SEhpSFeukLVe3cg9
 +5O+wBu+Jx7JfEyF9JNwdrWebHIVozT6N0VTqxSNEjrIsLOZ3R3dejl3APk21PLF2Oj8
 +Kb8ACZuKGttnfzoDexc2yloyF3/YUcCQzcDsr90PZvO0KOXZEocClY8eSC4NnFPV4xO
 lvhsU6vpfnm+pvKWrckJN/8r5bLtL/kaV4lfgkeSIGRnLzVQeQ+BBL7u23nOrwhO07G+
 JHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=DqY3ytm1lW24L4dBr5ZhfVe1Kl4JG7b6aElJixa0DtQ=;
 b=UzoJ0nJObRk5/OA/cwzPJvDVdguoj39ioSFL0LLKEPlQHLAMuONLE0oNsQQzCCFWAm
 Kef0CcKS0eomAlwNI73SkMzq7TxnU351SKAsZCZohoF4xiuDpvXws6vE2/IvRub+uyxk
 oKlhV4UOpwQcfaS0TdY9HZ2uIdaC+0HTgBroJpS2gHNr/9c8en8QNv44mXhcwTqZVpe5
 D4LAf5qkTUP49d5Rhpr5FSjdhM3LA1ybRCYzjy99N3Low7WCaSuWSpiwb8DN6wGtKFsB
 Z7um1tbhUjzAEqYEsgRJz08Nq/aTEXMOUqOkAmV2CNPO4H8Z8UXv1AnaLZNCIqX5sq6p
 yYrw==
X-Gm-Message-State: AOAM5308DPgBMEQ9CP+Y9aOH2mA6riyMfy4NOwTRBPA3OymIiqiGoMWc
 S6hbwX/GNWZc0U/VakDIkHg=
X-Google-Smtp-Source: ABdhPJxz+CTfYBRsr9wPZ8ehDJQEmTq++yYJr4Xo0s0U0R6hQKoUpOmBLcC8LM7TIOPThVoU3WYKbg==
X-Received: by 2002:a1c:234b:: with SMTP id j72mr7837172wmj.153.1599732997083; 
 Thu, 10 Sep 2020 03:16:37 -0700 (PDT)
Received: from ziggy.stardust ([213.195.113.201])
 by smtp.gmail.com with ESMTPSA id a127sm2936155wmh.34.2020.09.10.03.16.34
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 10 Sep 2020 03:16:36 -0700 (PDT)
Subject: Re: [trivial PATCH] treewide: Convert switch/case fallthrough; to
 break;
To: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
 Jiri Kosina <trivial@kernel.org>
References: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
From: Matthias Brugger <matthias.bgg@gmail.com>
Message-ID: <81d852d4-115f-c6c6-ef80-17c47ec4849a@gmail.com>
Date: Thu, 10 Sep 2020 12:16:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
Content-Language: en-US
X-Mailman-Approved-At: Thu, 10 Sep 2020 07:01:29 -0400
Cc: linux-fbdev@vger.kernel.org, oss-drivers@netronome.com,
 nouveau@lists.freedesktop.org, alsa-devel <alsa-devel@alsa-project.org>,
 dri-devel@lists.freedesktop.org, linux-mips@vger.kernel.org,
 linux-ide@vger.kernel.org, dm-devel@redhat.com, linux-mtd@lists.infradead.org,
 linux-i2c@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-afs@lists.infradead.org, linux-rtc@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, dccp@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
 kvmarm@lists.cs.columbia.edu, coreteam@netfilter.org,
 intel-wired-lan@lists.osuosl.org, linux-serial@vger.kernel.org,
 linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
 Kees Cook <kees.cook@canonical.com>, linux-media@vger.kernel.org,
 linux-pm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org,
 storagedev@microchip.com, ceph-devel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Nick Desaulniers <ndesaulniers@google.com>, linux-nfs@vger.kernel.org,
 linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
 linux-sctp@vger.kernel.org, iommu@lists.linux-foundation.org,
 netfilter-devel@vger.kernel.org, linux-crypto@vger.kernel.org,
 bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 09/09/2020 22:06, Joe Perches wrote:
> diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
> index 09f931d4598c..778be26d329f 100644
> --- a/drivers/net/wireless/mediatek/mt7601u/dma.c
> +++ b/drivers/net/wireless/mediatek/mt7601u/dma.c
> @@ -193,11 +193,11 @@ static void mt7601u_complete_rx(struct urb *urb)
>   	case -ESHUTDOWN:
>   	case -ENOENT:
>   		return;
> +	case 0:
> +		break;
>   	default:
>   		dev_err_ratelimited(dev->dev, "rx urb failed: %d\n",
>   				    urb->status);
> -		fallthrough;
> -	case 0:
>   		break;
>   	}
>   
> @@ -238,11 +238,11 @@ static void mt7601u_complete_tx(struct urb *urb)
>   	case -ESHUTDOWN:
>   	case -ENOENT:
>   		return;
> +	case 0:
> +		break;
>   	default:
>   		dev_err_ratelimited(dev->dev, "tx urb failed: %d\n",
>   				    urb->status);
> -		fallthrough;
> -	case 0:
>   		break;
>   	}

Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
