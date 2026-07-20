Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2754A3F12C3
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 14:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784557506; cv=none; b=BnAk2lcaHeN38N5oKk08ms9W+C1ckLYd9yDMN8ZH93t0KsToRLW1zpKvHjfKHbXX4B9636cvQZsVVWiC947NPGmYib5vEx+cbzsiImU9wRXjrACG1Z9zDLh04cKXvIij6jnmPCZKQOKwlQB2JWFL7dVRz7+35DLblJ/pAu5sSlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784557506; c=relaxed/simple;
	bh=TdLBwGKfpW2HQEQPSpNG6XRfTtfq1GMfxWAJBTED0rQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BAPvfXS0tHWTn0d1rIrnHnXaRiGaretnLy75xm4acmbfPSz8fdpNDo4xPejWyNe7uq0j6H6e9ddB8KVBMeYs844IPU+VM4hDgiTcMAXYMVah1DGrtw5e9DVaEJ8mnS+HQJwXBrkvHwwOjBP589Z3IxTOVfV9bdgLoFPV+s64RXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O96gp4Yu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O96gp4Yu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784557503;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XyYskVW5Q3OAyXu3DG/PTzV3maSXjfq/3t1Pihd5U2Y=;
	b=O96gp4YudDeb5SftSBff5Uwcwm8LMmwZHGU1nLpupRbZr54ooiULnUaDWnhfYbLfpSOktq
	GjFiP7xguiBI3LENLXbstXmu3M8JEDxPKwwurMqunWmUrbaNF289eDkxGofws4Ij3PeswL
	jWfDJZtnfgMz3VhkcYCAazBUAEPk2lQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-xaicgxkrOBOiSEuKXi2pSg-1; Mon, 20 Jul 2026 10:25:00 -0400
X-MC-Unique: xaicgxkrOBOiSEuKXi2pSg-1
X-Mimecast-MFC-AGG-ID: xaicgxkrOBOiSEuKXi2pSg_1784557499
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4955b84e25eso12247345e9.1
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 07:25:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784557499; x=1785162299;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XyYskVW5Q3OAyXu3DG/PTzV3maSXjfq/3t1Pihd5U2Y=;
        b=sTULa4h3sJ2OoKbXShx3nf6vOZARtW+BK8cLrTB6vJIrUhGkecPEwWBpSGS50CXyB6
         vaNdymISSVw7gZvgpR0EUXnawD21KWAPhjE0UhUOIW+HE+sXzhoTmf7zypkH6dE+Gw++
         2T8bfptoPYJ3g6b8vCmu5VDojGhK+mP9iYnm4VDkQf3/lW/wRM6iUz9pZd/3Qjk7jGRm
         FNg6uOvjRprDWJIUqd/xsZFAfP5gMwQBJvR8dkYDO9xbAhGVkc5GIZ39dDDVhtNEZ5cO
         QQmbNQCV1C4r9CVde2bRH0z1f6hpiyp9EunlIXucw0CMQQ5MXcttFLSoQ5LtPYSA73c6
         5ssg==
X-Forwarded-Encrypted: i=1; AHgh+RouUye3aR3zmrDqOXQBY4tkqN+P7pJsng1t/p/idanmxsZY1vTtra10KwcqLIp2GTJfzLakthg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxWDO4rlFL7pypLCympKWd77k3X1wh1DZkw5VbeTIjfnhKCeBTN
	Q7yKW6Psl1an1oS5dH5WDNprOsziKWsL9zVRt3z0nlNmK2HeEOnQBJsic1P0QrJdwa7n1/l3g89
	rs3QZpKAwCBM87FAHa3qmTCgRE+Cc06wLPJERqH3875XGjKGftnR5U2HhNA==
X-Gm-Gg: AfdE7cngQKQyJndoJFmTZlzePeD9NFcCrWfou+BX04AQvkyBSMphGIcNslICE42PTGn
	7MNUb0SXYpl1+ratr/l9/r6ObZntWRykUFoyqJtUWkwUaisRusG5sgYFO8tNwJv11KA0nd30KIG
	2YnU2kjy3UqSBl2QtIYJqsaRoWVFvw3pWtPRW7O0HMnvtMkGKGst5oKu3CjSSBcGVxh6j2Xqgy+
	5fARAxR6EcJgPDxMnU2HO5SvSj7yHFPtxVwMsuL+ckaOWnM1uhotVyBoXsXW344NL7COJ3HoVUj
	rwBrk9fCy2EzOPMTqJz7ssEQjhMYwVwHx5HLDKpUqUpTGclWjhDZwkYawjoE7Jb9OiNNF4+IIzm
	Nn7d17cr2UdVgQ/IGkHNanrg8fpkvvYC6O80iizllPqJ6WqOt
X-Received: by 2002:a05:600c:4755:b0:495:4a34:16e3 with SMTP id 5b1f17b1804b1-4954a3d0d04mr170864045e9.1.1784557499424;
        Mon, 20 Jul 2026 07:24:59 -0700 (PDT)
X-Received: by 2002:a05:600c:4755:b0:495:4a34:16e3 with SMTP id 5b1f17b1804b1-4954a3d0d04mr170863575e9.1.1784557498880;
        Mon, 20 Jul 2026 07:24:58 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2aa698sm261654155e9.4.2026.07.20.07.24.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2026 07:24:57 -0700 (PDT)
Message-ID: <b839f20a-da50-493c-9b71-78069b62b867@redhat.com>
Date: Mon, 20 Jul 2026 16:24:56 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v3 02/19] scripts: bug fixes in
 update-aarch64-cpu-sysreg-properties
To: Khushit Shah <khushit.shah@nutanix.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
Cc: cohuck@redhat.com, peter.maydell@linaro.org,
 richard.henderson@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 gshan@redhat.com, skolothumtho@nvidia.com, sebott@redhat.com,
 armbru@redhat.com, philmd@linaro.org, yangjinqian1@huawei.com,
 shaju.abraham@nutanix.com, mark.caveayland@nutanix.com,
 prerna.saxena@nutanix.com
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-3-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260716213858.609699-3-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3qE0_DatlPhbHvhyR8iNriF7tK9aOQmh3KQOPj5rYGQ_1784557499
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/16/26 11:38 PM, Khushit Shah wrote:
> - handle quoted bitstrings  and decimal
> - skip Values.ValueRange entries.
The above is the issue you reported on my v6. See my comment on the
other thread.
> - Emit unique RESx_{lsb} names for reserved fields so no two fields in
>   a register share a name.
The requirement for naming RES field needs to be explained. I understand
that now you expose all fields including those which are not writable it
may be required but at this stage I still fail why this is requested.
> - Emit a dummy 64-bit VAL field for registers with no defined fields,
>   such as AIDR_EL1 and REVIDR_EL1.
This is yet another functional change that could be separate.

Thanks

Eric
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  .../update-aarch64-cpu-sysreg-properties.py   | 67 +++++++++++++------
>  1 file changed, 45 insertions(+), 22 deletions(-)
>  mode change 100644 => 100755 scripts/update-aarch64-cpu-sysreg-properties.py
>
> diff --git a/scripts/update-aarch64-cpu-sysreg-properties.py b/scripts/update-aarch64-cpu-sysreg-properties.py
> old mode 100644
> new mode 100755
> index 9e829fda2e..ecc35db528
> --- a/scripts/update-aarch64-cpu-sysreg-properties.py
> +++ b/scripts/update-aarch64-cpu-sysreg-properties.py
> @@ -106,6 +106,29 @@ def collect_fields(item, bit_offset=0):
>  
>      return fields
>  
> +def parse_value_int(raw_val):
> +    if raw_val is None or isinstance(raw_val, bool):
> +        return None
> +
> +    # may already be real number
> +    if isinstance(raw_val, int):
> +        return raw_val
> +
> +    raw_str = str(raw_val).strip()
> +
> +    if "'" in raw_str:
> +        # quoted bitstring like "'0100'"
> +        bits = raw_str.replace("'", "")
> +        try:
> +            return int(bits, 2)
> +        except ValueError:
> +            return None
> +
> +    # unquoted, try decimal
> +    try:
> +        return int(raw_str, 0)
> +    except ValueError:
> +        return None
>  
>  def extract_field_enums(field):
>      enums = []
> @@ -124,32 +147,23 @@ def extract_field_enums(field):
>      if not isinstance(val_entries, list):
>          return enums
>  
> +    # A Values.ValueRange field specifies start and end value for a range.
> +    # Don't enumerate anything for them.
> +    for val_entry in val_entries:
> +        if isinstance(val_entry, dict) and \
> +           val_entry.get("_type") == "Values.ValueRange":
> +               return []
> +
>      for val_entry in val_entries:
>          if not isinstance(val_entry, dict):
>              continue
> -            
> +
>          if val_entry.get("_type") == "Values.Value":
> -            raw_val = val_entry.get("value")
> -            if raw_val is None:
> +            int_val = parse_value_int(val_entry.get("value"))
> +            if int_val is None:
>                  continue
> -                
> -            # some of the values have ' like "'0100'"
> -            raw_val_str = str(raw_val).strip().replace("'", "")
> -            
> -            try:
> -                # convert into bin 
> -                int_val = int(raw_val_str, 2)
> -            except ValueError:
> -                try:
> -                    # Fallback to dec if not bin
> -                    int_val = int(raw_val_str, 0)
> -                except ValueError:
> -                    continue
> -            
> -            enums.append({
> -                'value': int_val
> -            })
> -            
> +            enums.append({'value': int_val})
> +
>      return enums
>  
>  def generate_sysreg_properties_from_registers_json(id_reg_names, raw_json_path):
> @@ -210,7 +224,7 @@ def generate_sysreg_properties_from_registers_json(id_reg_names, raw_json_path):
>                         msb > current_fieldset_fields[unique_key]['msb']:
>                          enums = extract_field_enums(val)
>                          current_fieldset_fields[unique_key] = {
> -                            'raw_name': name,
> +                            'raw_name': unique_key,
>                              'lsb': lsb,
>                              'msb': msb,
>                              'width': width,
> @@ -238,6 +252,15 @@ def generate_sysreg_properties_from_registers_json(id_reg_names, raw_json_path):
>          # Sort decreasing lsbs
>          sorted_fields = sorted(unique_fields.items(),
>                                 key=lambda x: x[1]['lsb'], reverse=True)
> +        if len(sorted_fields) == 0:
> +            # cases like REVIDR_EL1 and AIDR_EL1.
> +            # augment a dummy fields VAL.
> +            sorted_fields.append(('VAL', {
> +                'lsb': 0,
> +                'msb': 63,
> +                'width': 64,
> +                'enums': []
> +            }))
>  
>          for unique_key, bits in sorted_fields:
>              enums_list = bits.get('enums', [])

