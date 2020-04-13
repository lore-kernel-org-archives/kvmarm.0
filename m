Return-Path: <SRS0=7dZW=56=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF04C2BA19
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 09:11:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7FB03206D5
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 09:11:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IuYqFbiH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7FB03206D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=amsat.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B77984B1DD;
	Tue, 14 Apr 2020 05:11:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JoV4+3pg8KFh; Tue, 14 Apr 2020 05:11:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D3474B1E2;
	Tue, 14 Apr 2020 05:11:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23BF64B16D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2020 17:34:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HvLm246TNKSe for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Apr 2020 17:34:23 -0400 (EDT)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D241A4B153
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2020 17:34:22 -0400 (EDT)
Received: by mail-wr1-f67.google.com with SMTP id d17so4945619wrg.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Apr 2020 14:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=sender:subject:to:cc:references:from:autocrypt:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=WDLpX6un52/AMwecGbJF0+8vb65HmQ8qFANqOY0XK7Y=;
 b=IuYqFbiHvSBMhlKLU88FQD6ph6l8u5128kLqE8SenvYihQJEPGmJINrkyvIh6vpW2u
 /atBvA75QL7UmEbyidSfCXE9VeE6SdB9IhYX6B3aHhwgMX0tmJ1dGgq1iHOBxSuH5Ezk
 VCWc51OJuo2eWBiWuYxF2kVCeRK0CX7KJ1dT2S+MSOGnulH5DMjtn5pZ88A/Y0yof0T2
 UcJ+AiMZeX97qHo6+sK6kWsJjsp0iuoGeKviv5k/BbU7JcMcpQXEn6SjrQEbaon0dw6S
 y7IERsJ3FCFJptrbidN9ACEH4G0Eg5BXm3yzzlYa9opYGLDAD1VPzulRpYMvxfhhzH+p
 vOlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-language:content-transfer-encoding;
 bh=WDLpX6un52/AMwecGbJF0+8vb65HmQ8qFANqOY0XK7Y=;
 b=clD9veJ/ziUTOHiUXHp/SA3zrX4fFj6B3tYXTmzOijQkPzEDwAcwQIHSvIwY1j8AFr
 NWxVsRSX0TYdGOBQmP60da9vGbC2V/lHVONQAUQ+nDLZ0XZnVBgpV9+6mfp6P7zDGVVJ
 ZiU3J15NS6kFooEUMdnfGikrdiIzeBnNh6o18jl0zvTuPlkD8TGdcouehwAvtOv2Rbgn
 TTKLi3WlFnf+7ZuD8fjbBZdlk/79flbGv2ElAngL+jpmkKbonabFcFUDTfd52yQkGBYd
 lKe8tp5guvnUiFOJOwYGdSWCAxZ1G6Nym9UkVcCOV5FQhr5MBVZystGK7I7rpMdnhAn0
 7eRw==
X-Gm-Message-State: AGi0Pub5CyLwV/67uraZ624d3nOYp6ozOX4+2Uy8d/yTHIBZvaMylBIN
 yqJmf0APbt2bDNwx7BCDL0Q=
X-Google-Smtp-Source: APiQypIaudaXPJ6rENC31BASdvEjjHEOZ24liPPj6hbZ7Im0hP2KXUJDynYo1n+j8lgnYgsqwzYqNQ==
X-Received: by 2002:a5d:5230:: with SMTP id i16mr14472562wra.71.1586813661849; 
 Mon, 13 Apr 2020 14:34:21 -0700 (PDT)
Received: from [192.168.1.39] (116.red-83-42-57.dynamicip.rima-tde.net.
 [83.42.57.116])
 by smtp.gmail.com with ESMTPSA id b11sm16503963wrq.26.2020.04.13.14.34.19
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 13 Apr 2020 14:34:21 -0700 (PDT)
Subject: Re: [PATCH] kvm_host: unify VM_STAT and VCPU_STAT definitions in a
 single place
To: Emanuele Giuseppe Esposito <eesposit@redhat.com>, kvm@vger.kernel.org
References: <20200413140332.22896-1-eesposit@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Autocrypt: addr=f4bug@amsat.org; keydata=
 mQINBDU8rLoBEADb5b5dyglKgWF9uDbIjFXU4gDtcwiga9wJ/wX6xdhBqU8tlQ4BroH7AeRl
 u4zXP0QnBDAG7EetxlQzcfYbPmxFISWjckDBFvDbFsojrZmwF2/LkFSzlvKiN5KLghzzJhLO
 HhjGlF8deEZz/d/G8qzO9mIw8GIBS8uuWh6SIcG/qq7+y+2+aifaj92EdwU79apZepT/U3vN
 YrfcAuo1Ycy7/u0hJ7rlaFUn2Fu5KIgV2O++hHYtCCQfdPBg/+ujTL+U+sCDawCyq+9M5+LJ
 ojCzP9rViLZDd/gS6jX8T48hhidtbtsFRj/e9QpdZgDZfowRMVsRx+TB9yzjFdMO0YaYybXp
 dg/wCUepX5xmDBrle6cZ8VEe00+UQCAU1TY5Hs7QFfBbjgR3k9pgJzVXNUKcJ9DYQP0OBH9P
 ZbZvM0Ut2Bk6bLBO5iCVDOco0alrPkX7iJul2QWBy3Iy9j02GnA5jZ1Xtjr9kpCqQT+sRXso
 Vpm5TPGWaWljIeLWy/qL8drX1eyJzwTB3A36Ck4r3YmjMjfmvltSZB1uAdo1elHTlFEULpU/
 HiwvvqXQ9koB15U154VCuguvx/Qnboz8GFb9Uw8VyawzVxYVNME7xw7CQF8FYxzj6eI7rBf2
 Dj/II6wxWPgDEy3oUzuNOxTB7sT3b/Ym76yOJzWX5BylXQIJ5wARAQABtDFQaGlsaXBwZSBN
 YXRoaWV1LURhdWTDqSAoRjRCVUcpIDxmNGJ1Z0BhbXNhdC5vcmc+iQJVBBMBCAA/AhsPBgsJ
 CAcDAgYVCAIJCgsEFgIDAQIeAQIXgBYhBPqr514SkXIh3P1rsuPjLCzercDeBQJd660aBQks
 klzgAAoJEOPjLCzercDe2iMP+gMG2dUf+qHz2uG8nTBGMjgK0aEJrKVPodFA+iedQ5Kp3BMo
 jrTg3/DG1HMYdcvQu/NFLYwamUfUasyor1k+3dB23hY09O4xOsYJBWdilkBGsJTKErUmkUO2
 3J/kawosvYtJJSHUpw3N6mwz/iWnjkT8BPp7fFXSujV63aZWZINueTbK7Y8skFHI0zpype9s
 loU8xc4JBrieGccy3n4E/kogGrTG5jcMTNHZ106DsQkhFnjhWETp6g9xOKrzZQbETeRBOe4P
 sRsY9YSG2Sj+ZqmZePvO8LyzGRjYU7T6Z80S1xV0lH6KTMvq7vvz5rd92f3pL4YrXq+e//HZ
 JsiLen8LH/FRhTsWRgBtNYkOsd5F9NvfJtSM0qbX32cSXMAStDVnS4U+H2vCVCWnfNug2TdY
 7v4NtdpaCi4CBBa3ZtqYVOU05IoLnlx0miKTBMqmI05kpgX98pi2QUPJBYi/+yNu3fjjcuS9
 K5WmpNFTNi6yiBbNjJA5E2qUKbIT/RwQFQvhrxBUcRCuK4x/5uOZrysjFvhtR8YGm08h+8vS
 n0JCnJD5aBhiVdkohEFAz7e5YNrAg6kOA5IVRHB44lTBOatLqz7ntwdGD0rteKuHaUuXpTYy
 CRqCVAKqFJtxhvJvaX0vLS1Z2dwtDwhjfIdgPiKEGOgCNGH7R8l+aaM4OPOd
Message-ID: <03a481a8-bcf2-8755-d113-71ef393508bf@amsat.org>
Date: Mon, 13 Apr 2020 23:34:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200413140332.22896-1-eesposit@redhat.com>
Content-Language: en-US
X-Mailman-Approved-At: Tue, 14 Apr 2020 05:11:35 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, David Hildenbrand <david@redhat.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

Hi Emanuele,

On 4/13/20 4:03 PM, Emanuele Giuseppe Esposito wrote:
> The macros VM_STAT and VCPU_STAT are redundantly implemented in multiple
> files, each used by a different architecure to initialize the debugfs
> entries for statistics. Since they all have the same purpose, they can be
> unified in a single common definition in include/linux/kvm_host.h
> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  arch/arm64/kvm/guest.c    | 23 +++++++--------
>  arch/mips/kvm/mips.c      | 61 +++++++++++++++++++--------------------
>  arch/powerpc/kvm/book3s.c |  3 --
>  arch/powerpc/kvm/booke.c  |  3 --
>  arch/s390/kvm/kvm-s390.c  |  3 --
>  arch/x86/kvm/x86.c        |  3 --
>  include/linux/kvm_host.h  |  3 ++
>  7 files changed, 43 insertions(+), 56 deletions(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 23ebe51410f0..3e3aee8b37c0 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -29,20 +29,17 @@
>  
>  #include "trace.h"
>  
> -#define VM_STAT(x) { #x, offsetof(struct kvm, stat.x), KVM_STAT_VM }
> -#define VCPU_STAT(x) { #x, offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU }
> -
>  struct kvm_stats_debugfs_item debugfs_entries[] = {
> -	VCPU_STAT(halt_successful_poll),
> -	VCPU_STAT(halt_attempted_poll),
> -	VCPU_STAT(halt_poll_invalid),
> -	VCPU_STAT(halt_wakeup),
> -	VCPU_STAT(hvc_exit_stat),
> -	VCPU_STAT(wfe_exit_stat),
> -	VCPU_STAT(wfi_exit_stat),
> -	VCPU_STAT(mmio_exit_user),
> -	VCPU_STAT(mmio_exit_kernel),
> -	VCPU_STAT(exits),
> +	{ "halt_successful_poll", VCPU_STAT(halt_successful_poll) },
> +	{ "halt_attempted_poll", VCPU_STAT(halt_attempted_poll) },
> +	{ "halt_poll_invalid", VCPU_STAT(halt_poll_invalid) },
> +	{ "halt_wakeup", VCPU_STAT(halt_wakeup) },
> +	{ "hvc_exit_stat", VCPU_STAT(hvc_exit_stat) },
> +	{ "wfe_exit_stat", VCPU_STAT(wfe_exit_stat) },
> +	{ "wfi_exit_stat", VCPU_STAT(wfi_exit_stat) },
> +	{ "mmio_exit_user", VCPU_STAT(mmio_exit_user) },
> +	{ "mmio_exit_kernel", VCPU_STAT(mmio_exit_kernel) },
> +	{ "exits", VCPU_STAT(exits) },
>  	{ NULL }
>  };
>  
[...]
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 6d58beb65454..e02d38c7fff1 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1130,6 +1130,9 @@ struct kvm_stats_debugfs_item {
>  #define KVM_DBGFS_GET_MODE(dbgfs_item)                                         \
>  	((dbgfs_item)->mode ? (dbgfs_item)->mode : 0644)
>  
> +#define VM_STAT(x, ...) offsetof(struct kvm, stat.x), KVM_STAT_VM, ## __VA_ARGS__
> +#define VCPU_STAT(x, ...) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU, ## __VA_ARGS__

I find this macro expanding into multiple fields odd... Maybe a matter
of taste. Sugggestion, have the macro define the full structure, as in
the arm64 arch:

#define VM_STAT(n, x, ...) { n, offsetof(struct kvm, stat.x),
KVM_STAT_VM, ## __VA_ARGS__ }

Ditto for VCPU_STAT().

> +
>  extern struct kvm_stats_debugfs_item debugfs_entries[];
>  extern struct dentry *kvm_debugfs_dir;
>  
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
