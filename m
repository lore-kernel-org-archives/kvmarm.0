Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F20E2EC08B
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 07:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758181238; cv=none; b=eQ/ELtREM01yrFlx4Wnzesz+CbYlEdTiGNYusCzdaz+RYTCmiCql2spEspBRbdYoM9/kqzuk8fpu3nJyWgG9nyA16zHGrbr23tabvj551kDlYvNnlxfQQLcgnssTRDWYK+wE0WjDKF2eZVyuq0/09E3c1VKY7o4l/S8YA7zTI94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758181238; c=relaxed/simple;
	bh=e1/HiDKEDbaCJpcl+RxPqzTkU514QriaU9XnVyArmzs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=eZW0h9mefviNWe0eWeoQcDMvzfF9TKaST3Xbq0qmmW8XCPd+Hi5sBrs1QFpnNtxozlKqK3YW4wz+ukX6OC4dsUZbZ9LlAuS2nPA6yJ1NQAaOYHCMj8mxIv3Gpq4myJXGzc+Y5PPl/qwzu28ITMpwuigCIMWi6YZGBhQ6sdN1dgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cS6r42YNTzRkHD;
	Thu, 18 Sep 2025 15:35:48 +0800 (CST)
Received: from dggpemf500013.china.huawei.com (unknown [7.185.36.188])
	by mail.maildlp.com (Postfix) with ESMTPS id 135C7180B5C;
	Thu, 18 Sep 2025 15:40:26 +0800 (CST)
Received: from [10.67.121.183] (10.67.121.183) by
 dggpemf500013.china.huawei.com (7.185.36.188) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Sep 2025 15:40:24 +0800
Message-ID: <e8515205-7ae9-4a1f-9f06-926aaf81a791@huawei.com>
Date: Thu, 18 Sep 2025 15:40:19 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/10] arm/cpu: more customization for the kvm host cpu
 model
To: Cornelia Huck <cohuck@redhat.com>, <eric.auger.pro@gmail.com>,
	<eric.auger@redhat.com>, <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>,
	<kvmarm@lists.linux.dev>, <peter.maydell@linaro.org>,
	<richard.henderson@linaro.org>, <alex.bennee@linaro.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <sebott@redhat.com>,
	<shameerali.kolothum.thodi@huawei.com>, <armbru@redhat.com>,
	<berrange@redhat.com>, <abologna@redhat.com>, <jdenemar@redhat.com>
CC: <agraf@csgraf.de>, <shahuang@redhat.com>, <mark.rutland@arm.com>,
	<philmd@linaro.org>, <pbonzini@redhat.com>, Zhou Wang
	<wangzhou1@hisilicon.com>, liuyonglong <liuyonglong@huawei.com>
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-9-cohuck@redhat.com>
From: Jinqian Yang <yangjinqian1@huawei.com>
In-Reply-To: <20250414163849.321857-9-cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500013.china.huawei.com (7.185.36.188)


On 2025/4/15 0:38, Cornelia Huck wrote:
> +/*
> + * decode_idreg_writemap: Generate props for writable fields
> + *
> + * @obj: CPU object
> + * @index: index of the sysreg
> + * @map: writable map for the sysreg
> + * @reg: description of the sysreg
> + */
> +static int
> +decode_idreg_writemap(Object *obj, int index, uint64_t map, ARM64SysReg *reg)
> +{
> +    int i = ctz64(map);
> +    int nb_sysreg_props = 0;
> +
> +    while (map) {
> +
> +        ARM64SysRegField *field = get_field(i, reg);
> +        int lower, upper;
> +        uint64_t mask;
> +        char *prop_name;
> +
> +        if (!field) {
> +            /* the field cannot be matched to any know id named field */
> +            warn_report("%s bit %d of %s is writable but cannot be matched",
> +                        __func__, i, reg->name);
> +            warn_report("%s is cpu-sysreg-properties.c up to date?", __func__);
> +            map =  map & ~BIT_ULL(i);
> +            i = ctz64(map);
> +            continue;
> +        }
> +        lower = field->lower;
> +        upper = field->upper;
> +        prop_name = g_strdup_printf("SYSREG_%s_%s", reg->name, field->name);
> +        trace_decode_idreg_writemap(field->name, lower, upper, prop_name);
> +        object_property_add(obj, prop_name, "uint64",
> +                            get_sysreg_prop, set_sysreg_prop, NULL, field);
> +        nb_sysreg_props++;
> +
> +        mask = MAKE_64BIT_MASK(lower, upper - lower + 1);
> +        map = map & ~mask;
> +        i = ctz64(map);
> +    }
> +    trace_nb_sysreg_props(reg->name, nb_sysreg_props);
> +    return 0;
> +}
> +

Hi,

There's a small issue here: the memory for `prop_name` has not been
freed. The memory allocated by `g_strdup_printf` needs to be released
using `g_free`.

diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index 1f69efe922..af39729fe0 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -446,6 +446,8 @@ decode_idreg_writemap(Object *obj, int index, 
uint64_t map, ARM64SysReg *reg)
          mask = MAKE_64BIT_MASK(lower, upper - lower + 1);
          map = map & ~mask;
          i = ctz64(map);
+
+        g_free(prop_name);
      }
      trace_nb_sysreg_props(reg->name, nb_sysreg_props);
      return 0;
-- 

Thanks,
Jinqian
