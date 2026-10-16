Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D42625B0BD
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 12:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792153979; cv=none; b=pyNYJqvT6iUuZHpzhQvuRCDDxUvdjnoNOI8RnehKps+k9TxzQd7XDw8RGYUAecjOG6X2/wp0PbyGzBt3I6yeNBCBuYxIgVLi+7Cn7DUcU6LT+Ntrs2I1cvTtUOPRUxshmUBwwrtAxN4m/1HaWnuvnExyTXBeaypC08RGcsn6G+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792153979; c=relaxed/simple;
	bh=sGms9Gdb5mwSCwzLWnk09keXPEdSvSfE8YngFkciJ6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MMYyK7zpYFNgDzbVDOe0ZEBXLRuSlVDZf4BgmccB+GegPE0RGmwZDJMtkrEgDUteMJM+GlMEyJTnLcVxITorILSGJoIXNwJUMyHmuLk89M4Eo8G2S0x4mx6kqmelFD+/8C8dTxTA6d0enfjvX3DCn6dkkzpZLpY1nAoIzSdvRB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GzysP48S; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GzysP48S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792153977;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Zwror2p8KN+DkhwJz1nlrN5PC2zqCKnxg3U809RTV4=;
	b=GzysP48S1/aFvZy69gteMz9TV8Tv1h2ojztKnggzM09SV5J1BLzfN/wFf15mOsDa68dW7C
	Srgvtqu/eLGNNH7G2lfFyH3niK7CMYg2F11Hmj+q+aY8NzfNm/xj0VH7KFBlObKoSpOj17
	5P8kN4edButIUTLob5yp0Yx1qpmikrg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-pJUCG36QMTWFFC562Kw_Gg-1; Fri, 16 Oct 2026 12:32:40 +0000
X-MC-Unique: pJUCG36QMTWFFC562Kw_Gg-1
X-Mimecast-MFC-AGG-ID: pJUCG36QMTWFFC562Kw_Gg_1792153959
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48dea677afcso746757f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 05:32:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792153958; x=1792758758;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/Zwror2p8KN+DkhwJz1nlrN5PC2zqCKnxg3U809RTV4=;
        b=d5qc7+KWQlxqooLP7O9etxR3653OCF1Plzm4/EZfDIe5CCoViioPdg9x6pc3LR/QNt
         Ux9Au/5Nn+TmzZuN9bBpDvEmnpWM2asoqZJREz2xXGCqzsAibz3isAUNWPWpIE1MMp3R
         sivUSV3mlDmQolfuVboks/HtmhrMgbgRIwGDZV69oH1bxoRSI01NrvPXduROpbzk3R9k
         urICgCwy4Pn6MT5ae9r3+wYzTSmuxzG/WvxUze/DYJJIwk1ushB3jkM55V6vanMt8IWa
         Sjx54m+iqZxIdDhv0lJgAucquDPyPBQTc3xHki5/KRRU007RS3ITguiSPeaKw9zVenHK
         DnSQ==
X-Forwarded-Encrypted: i=1; AKwUvBzz/j1YKe01Ei9doL265cXMfKXBrqoCpSCxFxtcbqpMq8O1Qer8v4CN5pDQ9d2zkC63dvGW4AU=@lists.linux.dev
X-Gm-Message-State: AFq9FYJ1BWaea1J31ECKRRWEJciv2tg4gCzHIg6fUS5ZCkq1HJdDyb7q
	QK/QZabW81150e8RU5cTtChdE/Ce47+7g/uuajLJ9Q4gqL+dnew9ngzzIk9LXwsnXATvITfRNPK
	14HsiJfcqHie9kGDMywAmdYj/Y0aRr4et+9ByMMhei2DyPJ18Q3XIxAkS2w==
X-Gm-Gg: AYBFou0dRpIZn95cFel1mCznd08y3Qc5zknm4vHgkDgkw41Nb8M/Atf437weKk+XrZ0
	mlAQLUFFgVMzoy6JElUJxm6K4lmQsFzqWprx8aniQem3ePtaopg217+ZFJV/P1GtR59uL5KgErr
	Y5XYcNGh16BUqTPuIOjOwp1DfkP4kmdszEOmWe42k8XoE3wDKWndVpDDrDno0Y25Sm+C0PM2W+z
	NXiTMuuUidDG751ZxdjF9FSElNtReQAg39B6i8LOS8GFrhN2LmWm/vWpdVaj+of/8bnm1mG9EuU
	487ScozNJOAE5I1Zu6JzvZMSiaCT0tj03TSkk9IvgxP37n/S7iZXXpRTO7nO8cBxTwJfJqQi16E
	Jvonlq34s/UOnGxEWSoT0wtWV6rPnshEfq7EK9RVejWWJ/ZWq
X-Received: by 2002:a05:6000:469b:b0:48a:f4b7:25c4 with SMTP id ffacd0b85a97d-48dfacf5408mr4857832f8f.1.1792153958299;
        Fri, 16 Oct 2026 05:32:38 -0700 (PDT)
X-Received: by 2002:a05:6000:469b:b0:48a:f4b7:25c4 with SMTP id ffacd0b85a97d-48dfacf5408mr4857781f8f.1.1792153957862;
        Fri, 16 Oct 2026 05:32:37 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4f9c41sm5130048f8f.38.2026.10.16.05.32.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 05:32:37 -0700 (PDT)
Message-ID: <fc9f71e8-7b5e-44ea-97a3-895ea050f8ef@redhat.com>
Date: Fri, 16 Oct 2026 14:32:35 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v4 19/25] target/arm/qmp: allow named CPU models on
 cpu-model-expansion
To: Khushit Shah <khushit.shah@nutanix.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
Cc: cohuck@redhat.com, peter.maydell@linaro.org,
 richard.henderson@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 gshan@redhat.com, skolothumtho@nvidia.com, sebott@redhat.com,
 armbru@redhat.com, philmd@linaro.org, yangjinqian1@huawei.com,
 shaju.abraham@nutanix.com, mark.caveayland@nutanix.com,
 ping@khushitshah.com, sandesh.patel@nutanix.com
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-20-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260921123249.1708067-20-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wdb0Ax5-lNP4SmIeA_DbLuUecZwlCtvB1S5GVeaeSt0_1792153959
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/21/26 2:32 PM, Khushit Shah wrote:
> Allow expansion of the new KVM-only named CPU models through the
> cpu-model-expansion QMP query.
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

we might need to add some new tests in tests/qtest/arm-cpu-features.c too

Eric
> ---
>  target/arm/arm-qmp-cmds.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/target/arm/arm-qmp-cmds.c b/target/arm/arm-qmp-cmds.c
> index 5fbdca3253..0940285af1 100644
> --- a/target/arm/arm-qmp-cmds.c
> +++ b/target/arm/arm-qmp-cmds.c
> @@ -36,6 +36,7 @@
>  #include <linux/kvm.h>
>  #include "system/kvm.h"
>  #include "cpu.h"
> +#include "cpu-models.h"
>  
>  static GICCapability *gic_cap_new(int version)
>  {
> @@ -96,6 +97,7 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>      Object *obj;
>      const char *name;
>      int fdarray[3];
> +    bool named_model = (arm_find_model(model->name) != NULL);
>      int i;
>  
>      if (type != CPU_MODEL_EXPANSION_TYPE_FULL) {
> @@ -108,6 +110,11 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>          return NULL;
>      }
>  
> +    if (!kvm_enabled() && named_model) {
> +        error_setg(errp, "The CPU type '%s' requires KVM", model->name);
> +        return NULL;
> +    }
> +
>      oc = cpu_class_by_name(TYPE_ARM_CPU, model->name);
>      if (!oc) {
>          error_setg(errp, "The CPU type '%s' is not a recognized ARM CPU type",
> @@ -121,6 +128,8 @@ CpuModelExpansionInfo *qmp_query_cpu_model_expansion(CpuModelExpansionType type,
>          if (!strcmp(model->name, "host") || !strcmp(model->name, "max")) {
>              /* These are kvmarm's recommended cpu types */
>              supported = true;
> +        } else if (named_model) {
> +            supported = true;
>          } else if (current_machine->cpu_type) {
>              const char *cpu_type = current_machine->cpu_type;
>              int len = strlen(cpu_type) - strlen(ARM_CPU_TYPE_SUFFIX);

