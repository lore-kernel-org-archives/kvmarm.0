Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E59AC2DD
	for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 06:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680158981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+HljoYyE0A4dfFt+IDGioQ59lFVM9ZhkEwh8bnOu3Vk=;
	b=A4tTl00OKsCiM8FlsgKpojNFAHyvEAisX1yoBgg4D/xQ+hnURawzx6tNsmFZsIoUvmSPL3
	uSe0F7BTERodZ47yEPGmF4hxpRIcr9YQBfVgx9tU4RIZuXPC3OHHCMEbbRBsMVk/1DyfGZ
	KcIPP+r6I1Hj6caM+VQt3IHazu0RTD8=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-XZZOSjRDPmqbhh4CLmmhvA-1; Thu, 30 Mar 2023 02:49:39 -0400
X-MC-Unique: XZZOSjRDPmqbhh4CLmmhvA-1
Received: by mail-pj1-f69.google.com with SMTP id b16-20020a17090a991000b0023f803081beso5497155pjp.3
        for <kvmarm@lists.linux.dev>; Wed, 29 Mar 2023 23:49:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680158978; x=1682750978;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+HljoYyE0A4dfFt+IDGioQ59lFVM9ZhkEwh8bnOu3Vk=;
        b=Fs577CylHo/Sp8xoIovrEFNnNHEqXdUTWDJ75nWFiqsyh3RY9FuG5uAB9xYyb4eUed
         rBx6T1TfmHrfn3aofhw43faXEsDzHbiMKiYQ4JJa0mt+ilWU3WcTUH2aw0+21r8XYHfZ
         uzaJ7CDKY/RQl8iIso6LEXLamc6C3fmqyufEoV7jOh8LeBRrkxCkRTLCUHuoudo3dL7Q
         owgrcAsGnufa8i0oufvnEi+X1fVyyk2eUnaZlAjnFTMVfw9PGLbOh6otLLJ23FMD2MfT
         5LwFsJCLhDyAc+0fNl7qh/rN0xm4ZBou7Xr7GP7H4Nhl6Gj5DJ9qyIiEl1cxuLxBnG40
         q6Ag==
X-Gm-Message-State: AAQBX9eFnyZr5rCL3iOpSJbbQSfhNY0DvtCEUL+zXMBbmOT3eLYE1KmG
	k5RUOCQN0QCXnOZKUUBPXJWAZGdChhEtoMF/v9E/+4tN8vESBacRYQxkD4MNgYGSpSfY5LxfP18
	VY1GvTmr336qWQM34
X-Received: by 2002:a05:6a20:7fa4:b0:d9:ec4b:82b4 with SMTP id d36-20020a056a207fa400b000d9ec4b82b4mr1754099pzj.1.1680158978539;
        Wed, 29 Mar 2023 23:49:38 -0700 (PDT)
X-Google-Smtp-Source: AKy350YtUaPWBGGCMAs8Xf3BCWlvYX/FlSXZ9uqmvdzXiNkbTZlWKF2YXQ5ww1SBp0SsotUVOky6RQ==
X-Received: by 2002:a05:6a20:7fa4:b0:d9:ec4b:82b4 with SMTP id d36-20020a056a207fa400b000d9ec4b82b4mr1754081pzj.1.1680158978270;
        Wed, 29 Mar 2023 23:49:38 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p18-20020a62ab12000000b005809d382016sm14403050pff.74.2023.03.29.23.49.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 23:49:37 -0700 (PDT)
Message-ID: <9412d307-3fd8-b694-7c18-8bf248070f3c@redhat.com>
Date: Thu, 30 Mar 2023 14:49:34 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v4 25/30] arm64: Change GNU-EFI imported code to use
 defined types
To: Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
 <20230213101759.2577077-26-nikos.nikoleris@arm.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230213101759.2577077-26-nikos.nikoleris@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Nikos,

On 2/13/23 18:17, Nikos Nikoleris wrote:
> Convert some types to avoid dependency on gnu-efi's <efi.h> and
> <efilib.h>.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>   arm/efi/reloc_aarch64.c | 9 +++------
>   1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/arm/efi/reloc_aarch64.c b/arm/efi/reloc_aarch64.c
> index 08672796..fa0cd6bc 100644
> --- a/arm/efi/reloc_aarch64.c
> +++ b/arm/efi/reloc_aarch64.c
> @@ -34,14 +34,11 @@
>       SUCH DAMAGE.
>   */
>   
> -#include <efi.h>
> -#include <efilib.h>
> - > +#include "efi.h"

In [PATCH v4 27/30] lib: Avoid external dependency in libelf. The 
Include header file changed again.

So why not move this change early?

diff --git a/arm/efi/reloc_aarch64.c b/arm/efi/reloc_aarch64.c
index fa0cd6bc..3f6d9a6d 100644
--- a/arm/efi/reloc_aarch64.c
+++ b/arm/efi/reloc_aarch64.c
@@ -34,8 +34,7 @@
      SUCH DAMAGE.
  */

-#include "efi.h"
-#include <elf.h>
+#include <efi.h>

Thanks,
Shaoqin
>   #include <elf.h>
>   
> -EFI_STATUS _relocate (long ldbase, Elf64_Dyn *dyn,
> -		      EFI_HANDLE image EFI_UNUSED,
> -		      EFI_SYSTEM_TABLE *systab EFI_UNUSED)
> +efi_status_t _relocate(long ldbase, Elf64_Dyn *dyn, efi_handle_t image,
> +		       efi_system_table_t *sys_tab)
>   {
>   	long relsz = 0, relent = 0;
>   	Elf64_Rela *rel = 0;

-- 
Shaoqin

