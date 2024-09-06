Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAF61A2C39;
	Fri,  6 Sep 2024 15:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725636750; cv=none; b=P7NeTC4pQ2/b0RNCdoqocAUlDc/G19R97yfA33RBMs+1WOMzIaX/NIC2oZ5B5Qtjngt9lUxqI4IXcxJBYrQgA5zaNhA89GXoDpWPNHlBvSFW3Xl7DX7wKalD3QenB4035XZogQJPa4IE7z1k5hh+ZptLpSNuP9hwDmPQFBrJ3bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725636750; c=relaxed/simple;
	bh=krjsuq3HBhcuxaQHBr9KpekfFKRQ2YCSUdVgMpOdeEg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=VijgcT5YM7oiyOYDvd/g6QmfcFW5M0xENw2cuYIeWFVV1Tv3YYxQqNrExGE3FWDu94snR4L49JnPx2egz6+Cddl7iSsEvAlD82ccEMDeBDMWmOL7TeEWMJNHzv4orbaW48Sh/KgGPHJRiijV6XmiamSSKISGaMM5Hlc3/onF2q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VsOtiC6u; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VsOtiC6u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725636749; x=1757172749;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=krjsuq3HBhcuxaQHBr9KpekfFKRQ2YCSUdVgMpOdeEg=;
  b=VsOtiC6u01dC0RsTTKybcloxvKnyZLVcNNkFzUKS3K8P/KEXceDcMBJl
   TbSNQ6jr/VN365I/8ARTX/Pp3kfyof+Fm4KLMsx4eWvyuiA/zYn/0E3pl
   VpDrfnsJYrObm5CZYr2c1F9lQlI35gnm/IGxw42hi2TfExpPS/0gQXmEa
   ExZh09lXrtIonerPOEAPShRYjuuKt8IweqyZy/MYERRu66a0ioKrgdsd+
   Om9swmqV4TeUP759ia3MmO5RZhamCEy+68pR9/jbmMBNkbCUpWN75p61b
   W49xH1WpK79By9FfaSf5TFDyyK9InqAnxNwujzsKbSCnHU0bVAJSYVBHY
   g==;
X-CSE-ConnectionGUID: +6MgOv55Rbq1dIm4NXzYVQ==
X-CSE-MsgGUID: 8ZEqF/lNTmuXyutyL6OT5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11187"; a="13412462"
X-IronPort-AV: E=Sophos;i="6.10,208,1719903600"; 
   d="scan'208";a="13412462"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2024 08:32:28 -0700
X-CSE-ConnectionGUID: 7hg6BEdBSyyGJbhlcVyp1Q==
X-CSE-MsgGUID: doAxGO40RJyWHOv1GYC2zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,208,1719903600"; 
   d="scan'208";a="70792221"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO localhost) ([10.245.246.62])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2024 08:32:15 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Masahiro Yamada <masahiroy@kernel.org>, da.gomez@samsung.com
Cc: Nathan Chancellor <nathan@kernel.org>, Nicolas Schier
 <nicolas@fjasle.eu>, Lucas De Marchi <lucas.demarchi@intel.com>, Thomas
 =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Rodrigo Vivi
 <rodrigo.vivi@intel.com>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 William Hubbs <w.d.hubbs@gmail.com>, Chris Brannon
 <chris@the-brannons.com>, Kirk Reiser <kirk@reisers.ca>, Samuel Thibault
 <samuel.thibault@ens-lyon.org>, Paul Moore <paul@paul-moore.com>, Stephen
 Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek
 <omosnace@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton
 <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby
 <jirislaby@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Bill
 Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, Simona
 Vetter <simona.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
 linux-kbuild@vger.kernel.org, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, speakup@linux-speakup.org,
 selinux@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-serial@vger.kernel.org,
 llvm@lists.linux.dev, Finn Behrens <me@kloenk.dev>, "Daniel Gomez
 (Samsung)" <d+samsung@kruces.com>, gost.dev@samsung.com
Subject: Re: [PATCH v2 3/8] drm/xe: xe_gen_wa_oob: fix
 program_invocation_short_name for macos
In-Reply-To: <CAK7LNAQDxVGOa5g3f_dqZ5nD_u8_a++T+ussL+AWuOXs-XOsow@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20240906-macos-build-support-v2-0-06beff418848@samsung.com>
 <20240906-macos-build-support-v2-3-06beff418848@samsung.com>
 <CAK7LNAQDxVGOa5g3f_dqZ5nD_u8_a++T+ussL+AWuOXs-XOsow@mail.gmail.com>
Date: Fri, 06 Sep 2024 18:32:08 +0300
Message-ID: <87h6asn6h3.fsf@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, 06 Sep 2024, Masahiro Yamada <masahiroy@kernel.org> wrote:
> On Fri, Sep 6, 2024 at 8:01=E2=80=AFPM Daniel Gomez via B4 Relay
> <devnull+da.gomez.samsung.com@kernel.org> wrote:
>>
>> From: Daniel Gomez <da.gomez@samsung.com>
>>
>> Use getprogname() [1] instead of program_invocation_short_name() [2]
>> for macOS hosts.
>>
>> [1]:
>> https://www.gnu.org/software/gnulib/manual/html_node/
>> program_005finvocation_005fshort_005fname.html
>>
>> [2]:
>> https://developer.apple.com/library/archive/documentation/System/
>> Conceptual/ManPages_iPhoneOS/man3/getprogname.3.html
>>
>> Fixes build error for macOS hosts:
>>
>> drivers/gpu/drm/xe/xe_gen_wa_oob.c:34:3: error: use of
>> undeclared identifier 'program_invocation_short_name'    34 |
>> program_invocation_short_name);       |                 ^ 1 error
>> generated.
>>
>> Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
>> Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
>> ---
>>  drivers/gpu/drm/xe/xe_gen_wa_oob.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/xe/xe_gen_wa_oob.c b/drivers/gpu/drm/xe/xe_=
gen_wa_oob.c
>> index 904cf47925aa..0d933644d8a0 100644
>> --- a/drivers/gpu/drm/xe/xe_gen_wa_oob.c
>> +++ b/drivers/gpu/drm/xe/xe_gen_wa_oob.c
>> @@ -8,6 +8,7 @@
>>  #include <errno.h>
>>  #include <stdbool.h>
>>  #include <stdio.h>
>> +#include <stdlib.h>
>>  #include <string.h>
>>
>>  #define HEADER \
>> @@ -30,6 +31,9 @@
>>
>>  static void print_usage(FILE *f)
>>  {
>> +#ifdef __APPLE__
>> +       const char *program_invocation_short_name =3D getprogname();
>> +#endif
>>         fprintf(f, "usage: %s <input-rule-file> <generated-c-source-file=
> <generated-c-header-file>\n",
>>                 program_invocation_short_name);
>>  }
>>
>> --
>> 2.46.0
>>
>>
>
>
>
> Before adding such #ifdef, you should check how other programs do.

IMO either option is preferred over adding #ifdefs.

BR,
Jani.


>
>
>
>
>
>
>
>
>
> Solution 1 : hard-code the program name
>
>
> diff --git a/drivers/gpu/drm/xe/xe_gen_wa_oob.c
> b/drivers/gpu/drm/xe/xe_gen_wa_oob.c
> index 106ee2b027f0..9e9a29e2cecf 100644
> --- a/drivers/gpu/drm/xe/xe_gen_wa_oob.c
> +++ b/drivers/gpu/drm/xe/xe_gen_wa_oob.c
> @@ -30,8 +30,7 @@
>
>  static void print_usage(FILE *f)
>  {
> -       fprintf(f, "usage: %s <input-rule-file>
> <generated-c-source-file> <generated-c-header-file>\n",
> -               program_invocation_short_name);
> +       fprintf(f, "usage: xe_gen_wa_oob <input-rule-file>
> <generated-c-source-file> <generated-c-header-file>\n");
>  }
>
>  static void print_parse_error(const char *err_msg, const char *line,
>
>
>
>
>
>
>
>
> Solution 2: use argv[0]
>
>
> diff --git a/drivers/gpu/drm/xe/xe_gen_wa_oob.c
> b/drivers/gpu/drm/xe/xe_gen_wa_oob.c
> index 106ee2b027f0..600c63e88e46 100644
> --- a/drivers/gpu/drm/xe/xe_gen_wa_oob.c
> +++ b/drivers/gpu/drm/xe/xe_gen_wa_oob.c
> @@ -28,10 +28,10 @@
>         "\n" \
>         "#endif\n"
>
> -static void print_usage(FILE *f)
> +static void print_usage(FILE *f, const char *progname)
>  {
>         fprintf(f, "usage: %s <input-rule-file>
> <generated-c-source-file> <generated-c-header-file>\n",
> -               program_invocation_short_name);
> +               progname);
>  }
>
>  static void print_parse_error(const char *err_msg, const char *line,
> @@ -136,7 +136,7 @@ int main(int argc, const char *argv[])
>
>         if (argc < 3) {
>                 fprintf(stderr, "ERROR: wrong arguments\n");
> -               print_usage(stderr);
> +               print_usage(stderr, argv[0]);
>                 return 1;
>         }

--=20
Jani Nikula, Intel
