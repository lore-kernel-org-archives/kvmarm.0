Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C8EC4332F
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 12:19:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D625640FF0;
	Fri,  4 Nov 2022 08:19:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9NjdzLh+b2L2; Fri,  4 Nov 2022 08:19:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3C6541021;
	Fri,  4 Nov 2022 08:19:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A2DF41066
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 08:19:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hXBOwQWX838c for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 08:19:41 -0400 (EDT)
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com
 [209.85.210.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DD93640FD3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 08:19:40 -0400 (EDT)
Received: by mail-pf1-f172.google.com with SMTP id k22so4379371pfd.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Nov 2022 05:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=lpOhz7OxgcyX16jnYCGIcgxXstL27/jHBLX3BQlZkeM=;
 b=cgzEgr24LoI9IjU+XM4EMk8dKD1ZuwOUoG2l29SwIwhDpdCk1rND+HSkQzPaFXXUun
 5cwqt4utz8zuQy+631yxcp8JeTFWa3eEkR6rLzF+IQQONAm77Re4+TeMpD3W2MH1BG0k
 xpw4hpqq2JLk9/rFoZ9a9PIltTd+TgIFu3ne1ijW4zZiDKY4Q2Lfnp1QKP/5fTQ/RXCF
 sGZicS+qqji92R8nClF8Qce3AOCsMhu2lWkuuNsR5EHcX1aF3PHTZeyjQrPGzGFRsP4k
 RN+MepWdTPb4gy5WMrWU7TZn6sYgVJl/ZAxP+ckrNg/JqvnI2g7HxwDXe6/hlJfR45wa
 16lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=lpOhz7OxgcyX16jnYCGIcgxXstL27/jHBLX3BQlZkeM=;
 b=dHiNiBSill7GuCRD4cwklQVqdvFn+8BwGL2i+C0R33xOmqJoekO+/qay0t8iaGIlmv
 xG+K+a24E1xibBBZQ/oSpKOBlfeJXAxwIATC+TsU5OmivvF6ZF/nqhnm9M4RIrzOVh5w
 HJBaT/vsI7jDX3p7XGqzD3+piNX2oGR/IcethLp4vh89an9ouVfGOcSLHHlc1DfEU5Jg
 5wyl9Dve0BDAVXyDj5cXw/y+cSVGDGcqkpA6N6oPmKrLAag6etGZDnaaR02P5kz4xbC5
 xipvUK3hq715d2In0pFjcUI46CD5hxrixhYp76TSaI0LJX4zzJiJWRUr1g8ExcBYK8Ij
 1YKg==
X-Gm-Message-State: ACrzQf3uccnOAzbz8p460K1aZaJcVv44OJ3dKevI8kJEn03mNyWIk1GZ
 XUwrhG9FVCiuDz29rL80lY0=
X-Google-Smtp-Source: AMsMyM7+wkqLB0hFLrfY0ZTPMLFgrcCEO0q4UBENhChoWBosKogPXniCnR6xUQqM7H+JaXD1DhGp0g==
X-Received: by 2002:a05:6a00:140a:b0:56c:b679:f812 with SMTP id
 l10-20020a056a00140a00b0056cb679f812mr35864191pfu.46.1667564379656; 
 Fri, 04 Nov 2022 05:19:39 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-17.three.co.id.
 [180.214.232.17]) by smtp.gmail.com with ESMTPSA id
 b6-20020a170903228600b001782a6fbcacsm2543892plh.101.2022.11.04.05.19.35
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 04 Nov 2022 05:19:39 -0700 (PDT)
Message-ID: <995a64b0-a9bb-05ce-85d1-6b5ee25ec0ef@gmail.com>
Date: Fri, 4 Nov 2022 19:19:32 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] kvm/arm: Fix pvtime documentation
To: Marc Zyngier <maz@kernel.org>
References: <20221103131210.3603385-1-usama.arif@bytedance.com>
 <24d81fe9-7cd1-71eb-8c35-0739f638b3df@gmail.com>
 <86fsf0qc1w.wl-maz@kernel.org>
 <4b2b78c6-9903-1247-9d16-fc6270aa34fc@gmail.com>
 <86cza3q8q5.wl-maz@kernel.org>
Content-Language: en-US
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <86cza3q8q5.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
 Usama Arif <usama.arif@bytedance.com>, fam.zheng@bytedance.com,
 punit.agrawal@bytedance.com, linux@armlinux.org.uk, liangma@liangbit.com,
 steven.price@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On 11/4/22 18:06, Marc Zyngier wrote:
> On Fri, 04 Nov 2022 01:48:21 +0000,
> Bagas Sanjaya <bagasdotme@gmail.com> wrote:
>>
>> On 11/3/22 22:42, Marc Zyngier wrote:
>>> No, this is the correct course of action. There isn't any point in
>>> having an *unrelated* change in a separate series. This is a
>>> standalone change, posted as a standalone patch.
>>>
>>>> Please reroll your series [2] with suggestion applied.
>>>
>>> Or not.
>>>
>>
>> You mean the series before this patch have already been applied,
>> right?
> 
> This change is 100% independent from the series you quoted. Why should
> there be a dependency between the two?
> 
> As for respinning the series at this stage for a documentation
> formatting issue, this is pretty pointless, and only clutters people's
> Inbox with redundant versions...
> 
> 	M.
> 

OK, thanks!

-- 
An old man doll... just what I always wanted! - Clara

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
