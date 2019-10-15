Return-Path: <SRS0=Qc2f=YI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3580DC10F14
	for <kvmarm@archiver.kernel.org>; Tue, 15 Oct 2019 16:37:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AB24120650
	for <kvmarm@archiver.kernel.org>; Tue, 15 Oct 2019 16:37:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eAy7IcvH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB24120650
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 155594A9C5;
	Tue, 15 Oct 2019 12:37:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TTyAb39okcIi; Tue, 15 Oct 2019 12:37:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D753F4A9CC;
	Tue, 15 Oct 2019 12:37:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6D204A9CA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Oct 2019 12:37:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U2vgnO9+5YJH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Oct 2019 12:37:44 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD06A4A9C5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Oct 2019 12:37:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1571157464;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references:openpgp:openpgp;
 bh=1jEbQ5iqOThUFULFTyIFEug52/ZAJJCm7u+tNv/e0Pk=;
 b=eAy7IcvHZyJZgNteHAkya8+rdSXPrC4gFj0wpf9kWa5zrm1CjPK+zzAIruK9G7UVZ/F12o
 DPKGqr8kmnRbdmT147jvloYoExZ+n7p1f/P8/r9YOfDcrgKxNnq2i+OJjJ45jt/e+h2tin
 4ITMZ+kTQJGya8Zw5srolvIWmN11C3Q=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-J8AJw0b8OaeMqUVAay_k9w-1; Tue, 15 Oct 2019 12:37:40 -0400
Received: by mail-wm1-f72.google.com with SMTP id m6so5746228wmf.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Oct 2019 09:37:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=/afoUvKJ/G8ziRnWqBlZqbL4cc1xk25yfAVgZZ9J6P4=;
 b=Ss5dfC2mHr/OlOraIxKJkhEp1CZrSCOYTv2xKame4a6WYDnTWYMD6qC8ed2comMpFI
 ELF+9PujG4AroVcEDs9HyvsDiTsakJj5vxBw+1z3eINKfCwcle4B8+unqzEL+1RarH3O
 0E3XmAdMK0XI6zArMrIwNLDUpAS/QIxAjANsHlo+vDNyIp4Z5tU73/rpO7HcOgv3elko
 ALnQXTCsyvO+kOcwBpnAloDeuqCeCzJMSqwP5HdfnG38F33vgByYkWoKrQDeWGOpBJQb
 djdMdxqC9tMbHnC+wb+8LtYJ0n+dEKrN+jWVUDQhj8Q+Mst830aYPRBScV7IgaheboWf
 Kdfw==
X-Gm-Message-State: APjAAAWGl76soj7wYc/GqXZA1iVFsAfzuetVRaokSnHyXJxURY/1Ncaw
 bTgh3MULPtjfm4dc7Vr3GAceHg8Zjbl4VYfUa48CaInbKkxRgwaKvdMFysf71UylstlbhVzvILu
 bMmkzywdoQk/44zeko/2hwT9O
X-Received: by 2002:a5d:4108:: with SMTP id l8mr30326072wrp.391.1571157459638; 
 Tue, 15 Oct 2019 09:37:39 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxipARbWgSrbXCwl1TEPdWRJHBQlN9VqVPvaKOq4EkdjYSYjz5KQDey2GKDwlfZaBSNuv9Oqg==
X-Received: by 2002:a5d:4108:: with SMTP id l8mr30326034wrp.391.1571157459287; 
 Tue, 15 Oct 2019 09:37:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d001:591b:c73b:6c41?
 ([2001:b07:6468:f312:d001:591b:c73b:6c41])
 by smtp.gmail.com with ESMTPSA id r65sm26602863wmr.9.2019.10.15.09.37.38
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 15 Oct 2019 09:37:38 -0700 (PDT)
Subject: Re: [PATCH v5 3/6] timekeeping: Add clocksource to
 system_time_snapshot
To: Jianyong Wu <jianyong.wu@arm.com>, netdev@vger.kernel.org,
 yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
 sean.j.christopherson@intel.com, maz@kernel.org, richardcochran@gmail.com,
 Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com
References: <20191015104822.13890-1-jianyong.wu@arm.com>
 <20191015104822.13890-4-jianyong.wu@arm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9274d21c-2c43-2e0d-f086-6aaba3863603@redhat.com>
Date: Tue, 15 Oct 2019 18:37:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191015104822.13890-4-jianyong.wu@arm.com>
Content-Language: en-US
X-MC-Unique: J8AJw0b8OaeMqUVAay_k9w-1
X-Mimecast-Spam-Score: 0
Cc: justin.he@arm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 nd@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 15/10/19 12:48, Jianyong Wu wrote:
> Sometimes, we need check current clocksource outside of
> timekeeping area. Add clocksource to system_time_snapshot then
> we can get clocksource as well as system time.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  include/linux/timekeeping.h | 35 ++++++++++++++++++-----------------
>  kernel/time/timekeeping.c   |  7 ++++---
>  2 files changed, 22 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
> index a8ab0f143ac4..964c14fbbf69 100644
> --- a/include/linux/timekeeping.h
> +++ b/include/linux/timekeeping.h
> @@ -194,23 +194,6 @@ extern bool timekeeping_rtc_skipresume(void);
>  
>  extern void timekeeping_inject_sleeptime64(const struct timespec64 *delta);
>  
> -/*
> - * struct system_time_snapshot - simultaneous raw/real time capture with
> - *	counter value
> - * @cycles:	Clocksource counter value to produce the system times
> - * @real:	Realtime system time
> - * @raw:	Monotonic raw system time
> - * @clock_was_set_seq:	The sequence number of clock was set events
> - * @cs_was_changed_seq:	The sequence number of clocksource change events
> - */
> -struct system_time_snapshot {
> -	u64		cycles;
> -	ktime_t		real;
> -	ktime_t		raw;
> -	unsigned int	clock_was_set_seq;
> -	u8		cs_was_changed_seq;
> -};
> -
>  /*
>   * struct system_device_crosststamp - system/device cross-timestamp
>   *	(syncronized capture)
> @@ -236,6 +219,24 @@ struct system_counterval_t {
>  	struct clocksource	*cs;
>  };
>  
> +/*
> + * struct system_time_snapshot - simultaneous raw/real time capture with
> + *	counter value
> + * @sc:		Contains clocksource and clocksource counter value to produce
> + * 	the system times
> + * @real:	Realtime system time
> + * @raw:	Monotonic raw system time
> + * @clock_was_set_seq:	The sequence number of clock was set events
> + * @cs_was_changed_seq:	The sequence number of clocksource change events
> + */
> +struct system_time_snapshot {
> +	struct system_counterval_t sc;
> +	ktime_t		real;
> +	ktime_t		raw;
> +	unsigned int	clock_was_set_seq;
> +	u8		cs_was_changed_seq;
> +};
> +
>  /*
>   * Get cross timestamp between system clock and device clock
>   */
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 44b726bab4bd..66ff089605b3 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -983,7 +983,8 @@ void ktime_get_snapshot(struct system_time_snapshot *systime_snapshot)
>  		nsec_raw  = timekeeping_cycles_to_ns(&tk->tkr_raw, now);
>  	} while (read_seqcount_retry(&tk_core.seq, seq));
>  
> -	systime_snapshot->cycles = now;
> +	systime_snapshot->sc.cycles = now;
> +	systime_snapshot->sc.cs = tk->tkr_mono.clock;
>  	systime_snapshot->real = ktime_add_ns(base_real, nsec_real);
>  	systime_snapshot->raw = ktime_add_ns(base_raw, nsec_raw);
>  }
> @@ -1189,12 +1190,12 @@ int get_device_system_crosststamp(int (*get_time_fn)
>  		 * clocksource change
>  		 */
>  		if (!history_begin ||
> -		    !cycle_between(history_begin->cycles,
> +		    !cycle_between(history_begin->sc.cycles,
>  				   system_counterval.cycles, cycles) ||
>  		    history_begin->cs_was_changed_seq != cs_was_changed_seq)
>  			return -EINVAL;
>  		partial_history_cycles = cycles - system_counterval.cycles;
> -		total_history_cycles = cycles - history_begin->cycles;
> +		total_history_cycles = cycles - history_begin->sc.cycles;
>  		discontinuity =
>  			history_begin->clock_was_set_seq != clock_was_set_seq;
>  
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
