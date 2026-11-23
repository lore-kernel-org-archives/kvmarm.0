Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.193
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795465105;
	b=ggPEOk4p19+paOAg9Dsi9DXjzUVZzNXFOb2Fk2Hs9VXA46ZYtPJ3tUJdfP+PoKXlMKX9
	 F8X56OaBYyNX5tMEzFdqj4lt3uDU5uIpirot1hqxPlVTiA0vRSOzIu4JPO/7BHeJ1s6MY
	 MdzZBQeONQLTQJhJqoYV+GVvwTw/6cqDVXs1kgOQpN6wtngaX0fxo1RMm6hPzVKh2Zvh6
	 4Jf8JH0Zpck6CisYWyudsHCVvUsklRV40Mrk7dGtSTHPszF5AVm/Ji/QVpbTYIvUQrg3L
	 fAtEbDDJ6GSHxvpIFcXQqshCQZ7WF0rcWg544xtXNZQFYMx2kQyefecwJA5N6thMttQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795465105;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=qX1iJKHEG9+QvOjSEHT3WU7TeQW7wThVjS178zhXy+4=;
	b=q2sX5MNzvRoVrLaVbGUm51tVqvg44lNKkRJU0MKW8Xnp8nrzqO1T4Z4o8qYPrTqWfffG
	 m/Mq3PxBACg6czvz1UzwxfhkGF7ZzoBMqJ5e8//8ktuVdseK9ARkUuCvfW6NWXlPtU+7Q
	 fPpEv/+c7eDZ46EDbqSC3lJ+oE743agXnB0WwwYALG1Sme8mYPuPtqQACollrKpk5A/Ah
	 qjSql8JJABrLHGWUOcFo3rahnFdbLcF11qzgR9VPH6LXwKcviSB7AeMaGAUAOTMFyjGXt
	 hJdYgw6Ukzx0tUKymtlza6G/Gh399EQrWDRXVCUkXunmI4QjMfg21mkrfqQHa18jC9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=upcscONh;
	arc=none smtp.remote-ip=95.215.58.193
Received: from mta1.migadu.com (out-193.mta1.migadu.com [95.215.58.193])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C4E606A31E
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 20:18:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29C4E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=upcscONh
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=aiKWy7zIB/oOMpcLNxVJc+AnXjQYawoYeQiKkvCngnM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795465102; v=1; x=1796069902;
 b=upcscONhJVt7d8lRAtUPwfLTrr+9x1Bwnp8qw7QLOStNae6exvYHrYsd7NsBoLgrSlwt5Z94
 /qTgrv7sDjcfJixm1CA3vu5LvL9FTl53nHyXeY8/QcmoUeYkgHWu8EOEJ2ZXpw8SngF4xce8Hi+
 ucMDheFVguOJR1edt9kBHjQA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 8dc164ced1afff00;
	Mon, 23 Nov 2026 20:18:21 +0000
X-Mizu-Trace-ID: 8dc164ced1afff00
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5c00d7ac49dso11969e87.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 12:18:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFAYc83M5vmVlNjoO5AZ1meCZkdaqv01eM8rvfQnAUbooKK89rhZbzjWtnBoU5ary06CrzTGI8=@lists.linux.dev
X-Gm-Message-State: APuU4Z/XTaZI5Nz6ZLYSQ+/AdAGawjE8Hft9RKR7EUDUppiHXKUk/VpE
	9rF4049yqeqVEYxUS30I7/Qj+QaavnpdO6oHCorp+1UvnVXoD6ngLvRtYMHlMDRtqvpgZbr1uBl
	KH63yW7DMiczhGR939NACNQiZo/a5Y8iJXwDHcfZV
X-Received: by 2002:a05:6512:3b07:b0:5c1:5972:4216 with SMTP id
 2adb3069b0e04-5c1c822007bmr314704e87.3.1795465100756; Mon, 23 Nov 2026
 12:18:20 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261117174403.58762-1-vdonnefort@google.com> <20261117174403.58762-20-vdonnefort@google.com>
In-Reply-To: <20261117174403.58762-20-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 23 Nov 2026 20:18:00 +0000
X-Gmail-Original-Message-ID: <CA+EHjTxshkWxw=hovdwDO=B-DiVMg1R5vv94iHDH0Aszp3czWA@mail.gmail.com>
X-Gm-Features: Aa3M54qdd1OMyU8bTqYh-0RSzzviCnT6SuQdd96WPnmdoS093ygj7s9tYKt3NGc
Message-ID: <CA+EHjTxshkWxw=hovdwDO=B-DiVMg1R5vv94iHDH0Aszp3czWA@mail.gmail.com>
Subject: Re: [PATCH v4 19/23] KVM: arm64: Add __pkvm_host_split_guest HVC
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com, weilin.chang@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Tue, 17 Nov 2026 17:43:58 +0000, Vincent Donnefort
<vdonnefort@google.com> wrote:
[...]
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 88af0aec1ea9..e264cfd41e0c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
[...]
> @@ -672,10 +677,8 @@ static u64 host_stage2_encode_gfn_meta(struct pkvm_hyp_vm *vm, u64 gfn)
>                 FIELD_PREP(KVM_HOST_PTE_OWNER_GUEST_GFN_MASK, gfn);
>  }
>
> -static int host_stage2_decode_gfn_meta(kvm_pte_t pte, struct pkvm_hyp_vm **vm,
> -                                       u64 *gfn)
> +static int host_stage2_decode_gfn_meta(kvm_pte_t pte, pkvm_handle_t *handle, u64 *gfn)
>  {
> -        pkvm_handle_t handle;
>          u64 meta;
>
>          if (WARN_ON(kvm_pte_valid(pte)))

Could you split the decode change and host_stage2_encode_annotation()
into separate patches?

Cheers,
/fuad
