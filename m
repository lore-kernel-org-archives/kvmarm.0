Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0EF4ED18A
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074054; cv=none; b=nHfAvZrytOUHQQXoebXkHSX5I84bzwEj1gBkdyk7susrFAKe6gCCSUor1+iSnxdWxuN44ENI095kVGleH6cmK6PxLSNx/iMMdN442i5y+rWvVGtJoymZQcdRFmNOaekf+SGixZAcQmENFHEmXuuJyp/33AGi2d0NQPqIijqxHYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074054; c=relaxed/simple;
	bh=i0FnZipHiUFJea3+anP00iB7peIqmAJuv6Py4rxIFAc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lUJLxNM+PZCm3zw5Nfgf5upg2Z5z73Ok4lsok4p0fiE1O0HmQPdtIadv2A3WkgwlZ/e5ra4bh0Tzyi6ppr225RtCucAqC2FenlEaZ4dO8DGqm9ezxEQLGJjSvJkEAkHMj8vQggsAyoBeO8z1Hd/KJXi+INRe1jO/2cH6GsgM3MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vetj8vD+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vetj8vD+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792074051;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DD5iEbr+JLWkq6bQIgWITScf5DDXuPDK80oahfo5A0o=;
	b=Vetj8vD+AH3EakcsbheWvQvtev3YTSPHT4TZCsTvdbjqbEoFzl8n9o4h3js3XGTGTGN15R
	VhHCiQ/kQqbgRwIwcnxJjnUfAFhEj1lgC5fHPTJQ3g9SZYefzqvXOMaOlmcZb4JBLlLf8t
	Le4ZVsG/nicwJod8GaL4im6+o65F4+w=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-YajE4jTUMBCQl-e5gbydqw-1; Thu, 15 Oct 2026 14:20:49 +0000
X-MC-Unique: YajE4jTUMBCQl-e5gbydqw-1
X-Mimecast-MFC-AGG-ID: YajE4jTUMBCQl-e5gbydqw_1792074048
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4994d67d0e3so15139685e9.2
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 07:20:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792074048; x=1792678848;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DD5iEbr+JLWkq6bQIgWITScf5DDXuPDK80oahfo5A0o=;
        b=c9jLbC76ox36D97ov715u8gOetqcBzT/qGbQ/7VyRibI6ZJvVlES/WkX3CU6pzneay
         oiDFD/xWhTO5pwLj1pc3RLxBNfOV+mk9B1i6vmkYSh5UyVZCgfInCgNxVaW4QU+EAjQ8
         rsir4f45krbxuX7+SE6Tc1uMt1yAgxX8NF50h7QzcnSGNS2wmbUXvBiIIYaiFbPb671M
         MhJvTMz8EgN4e1sxQss3P+wGSnQHl4v7a0n7cSUNeO6s8m6/5B57lllgRqW/mU7Zlkzq
         IzOIQZKet9X3Z3tn0GzyX1qSkU8AM8SfKyFiSoPD2m3MSvRKTavFuta44sAtQKPnak9e
         LA5g==
X-Forwarded-Encrypted: i=1; AKwUvBy6s62V38SVwJ1M4aMKCPewSF4kTngQPLgkmkNw3oVt5ogeoJLgOI29MbE8uNEz0Tc+27o7Mo8=@lists.linux.dev
X-Gm-Message-State: AFq9FYJtGiYmtk/GjQzAfX/2aUYmkyEO3bGiKpgbE9tLQwsEJC7ZRXBa
	LsZGmS1mNIddPLvwwb0jRNu93idS9+yxj49m+AI7p0jwDb8ZUKoUKPiQcq3KkT+JtUXqZFM065p
	cnIGvShBNUaWqmjQrypwcErHMiUoB4L3yG8lxZ1cxn3vJqNN8vFhEeUfCJQ==
X-Gm-Gg: AYBFou3BQLT2v9jfDDQv8O/1W1aecVdaUVbNjuPSMomfvRmOEHxuZG4O58JvlG1q52B
	dir6LdELRD0JoKz3vBlOXBt7pwOG01rkAOf3HnxAOFZUjvBxcdJUQJCYyR/w+gN4+Ayi+nSnV2H
	J06RK6fxKmxa0GkaIEyOqgTgeVrEVUVvTchIqulGVrnVho2dw8f8qmSEAqEClosm8PO0eBLs2im
	y54WrYjdvPhjlWBYW0O/dNdhCISURyGR2re3x2ude2GIpX+lwrpCts7Qa65fiJ8NJp8XbDruvyW
	7AL/gBIbe+sG108YSnvlzJy3SynUoATGqc5FMvNyfwZTBr2PefNZda4zz/AaIhQkRhfqv7TqDvY
	Kdx9NxseRoQV+kwfTmbRMaTsddjF6TlV3UyPU1vDVmZgQ5Nl4
X-Received: by 2002:a05:600c:a4b:b0:4a0:23f:8b0d with SMTP id 5b1f17b1804b1-4a1af68d397mr173679325e9.2.1792074048079;
        Thu, 15 Oct 2026 07:20:48 -0700 (PDT)
X-Received: by 2002:a05:600c:a4b:b0:4a0:23f:8b0d with SMTP id 5b1f17b1804b1-4a1af68d397mr173678615e9.2.1792074047479;
        Thu, 15 Oct 2026 07:20:47 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd97ed33sm85893405e9.5.2026.10.15.07.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2026 07:20:46 -0700 (PDT)
Message-ID: <543a8f0a-bd66-4c13-8117-07f069a754d8@redhat.com>
Date: Thu, 15 Oct 2026 16:20:45 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v4 23/25] qmp: add query-cpu-props-info command
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
 <20260921123249.1708067-24-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260921123249.1708067-24-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: T1OilhP1s3Hj2pcCp2Pg8wTfpOKFs_xt52NgDa7_Nj0_1792074048
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/21/26 2:32 PM, Khushit Shah wrote:
> Introduce the 'query-cpu-props-info' QMP command. For each CPU model
> property, it reports the type (boolean or number) and the set of values
> supported under the active accelerator and host.
>
> This helps the management stack to discover which values are supported
> for a given CPU property. This is especially important for non-boolean
> properties, where knowing that the host has value 'x' does not
> inherently reveal the full range of valid values supported on the host.
> For example, an Arm host with CTR_EL0.L1Ip=3 (PIPT) also allows 2
> (VIPT) but a host with CTR_EL0.L1Ip=2 does not allow CTR_EL0.L1Ip=3
> for a guest.
>
> For numerical properties, the supported values are expressed as a list
> of inclusive {min, max} ranges. For boolean properties, they are
> represented as a list of true/false values.
>
> The command and its return types (CpuPropertyType, CpuPropertyInfo and
> friends) are defined in qapi/machine.json rather than an Arm-specific
> schema, since the concept applies to other targets (e.g. x86, RISC-V)
> too. Targets that do not implement it return an error.
> (The following commit implements the command for Arm KVM.)
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  qapi/machine.json          | 82 ++++++++++++++++++++++++++++++++++++++
>  stubs/meson.build          |  1 +
>  stubs/qmp-cpu-props-info.c | 12 ++++++
>  tests/qtest/qmp-cmd-test.c |  1 +
>  4 files changed, 96 insertions(+)
>  create mode 100644 stubs/qmp-cpu-props-info.c
>
> diff --git a/qapi/machine.json b/qapi/machine.json
> index 2d63c1bac3..6e65bdad86 100644
> --- a/qapi/machine.json
> +++ b/qapi/machine.json
> @@ -2291,3 +2291,85 @@
>  # Since: 1.2
>  ##
>  { 'command': 'query-cpu-definitions', 'returns': ['CpuDefinitionInfo'] }
> +
> +##
> +# @CpuPropertyType:
> +#
> +# The type of a CPU model property.
> +#
> +# @boolean: the property is of type boolean.
> +#
> +# @number: the property is of type unsigned integer.
> +#
> +# Since: 11.2
> +##
> +{ 'enum': 'CpuPropertyType',
> +  'data': [ 'boolean', 'number' ] }
why do we still need the boolean type? Can't we simplify and stick to
uint64_t for all SYSREG props?
> +
> +##
> +# @CpuPropertyValueRange:
> +#
> +# An inclusive range of numeric values supported for the property.
> +#
> +# @min: the lowest supported value.
> +#
> +# @max: the highest supported value.
> +#
> +# Since: 11.2
> +##
> +{ 'struct': 'CpuPropertyValueRange',
> +  'data': { 'min': 'uint64', 'max': 'uint64' } }
> +
> +##
> +# @CpuPropertyInfoBoolean:
> +#
> +# @supported-values: list of boolean values supported for the
> +#     property.
> +#
> +# Since: 11.2
> +##
> +{ 'struct': 'CpuPropertyInfoBoolean',
> +  'data': { 'supported-values': ['bool'] } }
why can't you model that with a range too?
> +
> +##
> +# @CpuPropertyInfoNumber:
> +#
> +# @supported-values: list of numeric value ranges supported
> +#     for the property.
> +#
> +# Since: 11.2
> +##
> +{ 'struct': 'CpuPropertyInfoNumber',
> +  'data': { 'supported-values': ['CpuPropertyValueRange'] } }
> +
> +##
> +# @CpuPropertyInfo:
> +#
> +# Information about a single CPU model property, including the values
> +# the host/accelerator supports for it.
> +#
> +# @name: the name of the property.
> +#
> +# @type: the type of the property, which selects the layout of
> +#     @supported-values.
> +#
> +# Since: 11.2
> +##
> +{ 'union': 'CpuPropertyInfo',
> +  'base': { 'name': 'str',
> +            'type': 'CpuPropertyType' },
> +  'discriminator': 'type',
> +  'data': { 'boolean': 'CpuPropertyInfoBoolean',
> +            'number': 'CpuPropertyInfoNumber' } }
> +
> +##
> +# @query-cpu-props-info:
> +#
> +# Return information about the CPU model properties.  For each
> +# property it reports the values supported under the active
> +# accelerator and host.
> +#
> +# Since: 11.2
> +##
> +{ 'command': 'query-cpu-props-info',
> +  'returns': ['CpuPropertyInfo'] }
> diff --git a/stubs/meson.build b/stubs/meson.build
> index 3b2f2680b1..3bb4028bab 100644
> --- a/stubs/meson.build
> +++ b/stubs/meson.build
> @@ -83,6 +83,7 @@ if have_system
>    stub_ss.add(files('qmp-i386-sgx.c'))
>    stub_ss.add(files('qmp-i386-xen.c'))
>    stub_ss.add(files('qmp-cpu.c'))
> +  stub_ss.add(files('qmp-cpu-props-info.c'))
>    stub_ss.add(files('qmp-cpu-s390x.c'))
>    stub_ss.add(files('qmp-cpu-s390x-kvm.c'))
>    stub_ss.add(files('hmp-cmd-info_mem.c'))
> diff --git a/stubs/qmp-cpu-props-info.c b/stubs/qmp-cpu-props-info.c
> new file mode 100644
> index 0000000000..36b0530b98
> --- /dev/null
> +++ b/stubs/qmp-cpu-props-info.c
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +
> +#include "qemu/osdep.h"
> +#include "qapi/error.h"
> +#include "qapi/qapi-commands-machine.h"
> +
> +CpuPropertyInfoList *
> +qmp_query_cpu_props_info(Error **errp)
> +{
> +    error_setg(errp, "query-cpu-props-info not supported on this target");
> +    return NULL;
> +}
> diff --git a/tests/qtest/qmp-cmd-test.c b/tests/qtest/qmp-cmd-test.c
> index 279a8f5614..2c25dbd8cb 100644
> --- a/tests/qtest/qmp-cmd-test.c
> +++ b/tests/qtest/qmp-cmd-test.c
> @@ -100,6 +100,7 @@ static bool query_is_ignored(const char *cmd)
>          "add-fd",
>          /* Success depends on target arch: */
>          "query-cpu-definitions",  /* arm, i386, ppc, s390x */
> +        "query-cpu-props-info", /* arm + kvm */
>          "query-gic-capabilities", /* arm */
>          "query-s390x-cpu-polarization", /* s390x */
>          /* Success depends on target-specific build configuration: */
Thanks

Eric

