Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768E133D50F
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 16:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787241609; cv=none; b=AdAfchRFrSHB+n2xFSCod1IAhja9WblJQrwSVH37vN/kZOgUsUWpey/MNhGsgzewtDO6PpBz6Mu+AEiZb5Tb8Ir4QcGrwa444+SZ+FNyuo5Jqhl5OjGskX/Auq5Z9/HfFIOeDxtkugJUIvyy0eQSyJeT8sgzqANm5pI13j/a/JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787241609; c=relaxed/simple;
	bh=dLGct2CP/RH8v810vgDy1wdBZb9Lqt4S296/+UXW7As=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KbPc+wAksQv1iNy8M2BSDdP33yj9gvIBV3QuVZD+NWMDHtuSvdA/GWPw9xarx3KxJcbv2I1CX6J1yxtOkDfsuVoRH7DG10y3pGBC+4kEN/7Np85gypubtWpd2zWYV/g+kUol/4ZhPbZDG/0AUIhoH3B5aecZq+b+PGzztr3Z9Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y4I5hlRX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y4I5hlRX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787241606;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oZpnNd3w2FeRT91TmQD+DZHP1JTROZ79FdNVrJcBD2g=;
	b=Y4I5hlRXXp3+zljcj4SNpqdEw5TXuFVyVhA7IXDipI0C+X4eevTcAz1qxStCFKjwPsKs8o
	Ucy0mvGSFohrpyd9r26oaKz1TVRsIFJBcxM19vOWteySdr1TEJ4/WUWPWlJSd3ube5if2V
	Rzx65ev3HjkbL0xjGuIsvBj12vX3Odg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215--ozQORXVM5uqDQ9YV1Z9zg-1; Thu, 20 Aug 2026 12:00:05 -0400
X-MC-Unique: -ozQORXVM5uqDQ9YV1Z9zg-1
X-Mimecast-MFC-AGG-ID: -ozQORXVM5uqDQ9YV1Z9zg_1787241604
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47eaa4006a1so564262f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 09:00:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787241604; x=1787846404;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oZpnNd3w2FeRT91TmQD+DZHP1JTROZ79FdNVrJcBD2g=;
        b=D5CTWroCXcWTe/jf+IVxprh5XX3N1AYT41ThBZE6YhuUd6fUR2I2nmsse7jISGyGTr
         +bC5JGZsuSIiJl3//tf1aWKQLEHTaNM6erxIq2EGg5QKxnXj91lVM7KjKXeYDJ0epzE6
         VbFtT/bKolYH3Y6TUWZv0+a3fYt+nCwEbALpf9gcDnqB70iy2lY5Ci6QYFRRPgbRO/5v
         VmOYYKaIuqO4klOcELgEua4vrOoBgGdnZ0xhav5lLBp8T7atw05mkgiMEPJt4rbfoK4E
         Eq7Ssrjth0Il/Y+YKLDiG77HTF5cm/lVTzB+/6u5aHjP7HsEoEtk1vp39C0VRjWrIfNM
         4mqg==
X-Forwarded-Encrypted: i=1; AHgh+RpiZ9JESXsgIA9roEopATh/3S8i6L6r/0KCXsx3iJc9cIbKOgAqkNAMjiwgm5S4Lza9QWzk92M=@lists.linux.dev
X-Gm-Message-State: AFuF++nfGtxLSVkC3tRTvkyO+OamKKTsqPmQ3TFGCcyo8enGgQi3P4dE
	4Dpck4TiG75ZwhbUBQzuE1LMvfoCCLIfn9m/XwXJoKpsaf2T7F1jzNmkeD6TXiQJyqzDc1m30Cj
	1PMnYVj7iaclM4KbKnKGZXbCSqWTo0lBqwotZDqCkaSguobo7qynnQ2aqEg==
X-Gm-Gg: AR+sD126z6N+qG+Ds4+UGNCc9UNL9zjccd29lPBJmahfsmhwoV+e6h/4EGpzQhIQv04
	Z5TDsGj3NsWjiL3AceeVSL4lvT8xa3vv/g0SN+SPiA0+aCg2ThnYdrG0veTEpA8+27zydjsAyDw
	X3oRFS8lNG5IupJiLB2gcYjZQ12xvYEYSoiudwy9F8kiB5bNEIZRDFJa2KFBuh4VDRt3f4JHlz/
	BXRlGFDbUJ8c663XljTenwaamlgxvaud1UJ3puqk+mCq09jE2CtsmIHqvwqZDZjZlZq2pGh6G0j
	ama0ghMs0NYGFkqAtlKL824YNNKVep+yNkWKd5aq0yqE9eMeYMmWrffe2mfMeA3ExJ9wV7mobLC
	YzzbqBdGtEANNBKduGr7cKfHvJzOEXKaRZcx8lzdIQWi9mffU
X-Received: by 2002:a05:6000:70a:b0:47f:9158:5924 with SMTP id ffacd0b85a97d-482b784d37cmr13171267f8f.9.1787241603714;
        Thu, 20 Aug 2026 09:00:03 -0700 (PDT)
X-Received: by 2002:a05:6000:70a:b0:47f:9158:5924 with SMTP id ffacd0b85a97d-482b784d37cmr13171139f8f.9.1787241603253;
        Thu, 20 Aug 2026 09:00:03 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482b14cf0a3sm13347113f8f.32.2026.08.20.09.00.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 09:00:02 -0700 (PDT)
Message-ID: <4a9bb4de-9e85-4ba2-a9b3-68b4fbafd5e3@redhat.com>
Date: Thu, 20 Aug 2026 18:00:00 +0200
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
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>,
 "gshan@redhat.com" <gshan@redhat.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "philmd@linaro.org" <philmd@linaro.org>,
 "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 Mark Cave-Ayland <mark.caveayland@nutanix.com>,
 Prerna Saxena <prerna.saxena@nutanix.com>
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-3-khushit.shah@nutanix.com>
 <b839f20a-da50-493c-9b71-78069b62b867@redhat.com>
 <7B85F7CA-C4CB-4EAD-BCB1-6D2135934F5B@nutanix.com>
 <8d9e5cef-526e-4d4f-86a2-d86bdaeabd34@redhat.com>
 <D0C8CE98-55F0-475C-AC56-731A3858E5D2@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <D0C8CE98-55F0-475C-AC56-731A3858E5D2@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QJ8_ZNIRT2Dvefo9LSSgBiVCQbMC0Cty3Hid3RCV4Eo_1787241604
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 8/18/26 11:43 AM, Khushit Shah wrote:
>
>> On 14 Aug 2026, at 7:15 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>>
>>
>> On 8/3/26 4:32 PM, Khushit Shah wrote:
>>>> On 20 Jul 2026, at 7:54 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>>>
>>>> !-------------------------------------------------------------------|
>>>> CAUTION: External Email
>>>>
>>>> |-------------------------------------------------------------------!
>>>>
>>>>
>>>>
>>>> On 7/16/26 11:38 PM, Khushit Shah wrote:
>>>>> - handle quoted bitstrings  and decimal
>>>>> - skip Values.ValueRange entries.
>>>> The above is the issue you reported on my v6. See my comment on the
>>>> other thread.
>>> Acked.
>>>>> - Emit unique RESx_{lsb} names for reserved fields so no two fields in
>>>>> a register share a name.
>>>> The requirement for naming RES field needs to be explained. I understand
>>>> that now you expose all fields including those which are not writable it
>>>> may be required but at this stage I still fail why this is requested.
>>> I think we don’t need to expose RES fields to users. 
>>> I was thinking of case where a RES0 field is repurposed for
>>> something else, but that should be taken care by zeroing the
>>> ID regs array before initiating the named model hierarchy.
>>> (RES1 field in CTR_EL0 needs some handling).
>> I also think so. you can rely on AARCHMRS desc to identify the right
>> default values.
> Acked.
>
>>> On why we even need to expose non-writable fields:
>>> - Assume some non-writable field mismatches for the model and
>>>  host, why do we want to stop users from explicitly overriding
>>>  the model's field value to host value?
>> I agree this needs to be checked. However as I suggested I think you can
>> avoid exposing them to the end-users as props. You just need to read the
>> value from host and compare it with the value set in the named model. 
> I am not sure how that will work, assume following scenario:
>
> - Host is running on `neoverse-v2` core and we want to run guest with `neoverse-v1`
>   model. “pauth” fields are not exactly writable, and "neoverse-v1” implements
>   different pauth algorithm than "neoverse-v2”. Now, if we don’t expose “pauth” as
>   it is not writable, how will end user be able to say I want to run neoverse-v1
>   model so please disable "pauth”.
>
> What I want to support is end user to say "please use the host value for some non-writable
> fields as the model I want to run has values which are not supported on the current host.”
OK I see your point now. sorry for the misunderstanding. So in that case
effectively you need a true QEMU prop for each field even for those
which are not KVM writable. Please ignore my previous reply ;-)

Thanks

Eric
>
> The same “pauth” example will suffer if we don’t expose APA/GPA in cpu-model-expansion,
> how will management stack infer that both host supports “pauth" but they support different
> versions and are not compatible?
>
> Warm Regards,
> Khushit
>
>>>
>>>>> - Emit a dummy 64-bit VAL field for registers with no defined fields,
>>>>> such as AIDR_EL1 and REVIDR_EL1.
>>>> This is yet another functional change that could be separate.
>>> Acked, will do in v4.
>> Thanks
>>
>> Eric
>>>> Thanks
>>>>
>>>> Eric
>>>>> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
>>>>> ---
>>>>> .../update-aarch64-cpu-sysreg-properties.py   | 67 +++++++++++++------
>>>>> 1 file changed, 45 insertions(+), 22 deletions(-)
>>>>> mode change 100644 => 100755 scripts/update-aarch64-cpu-sysreg-properties.py
>>>>>
>>>>> diff --git a/scripts/update-aarch64-cpu-sysreg-properties.py b/scripts/update-aarch64-cpu-sysreg-properties.py
>>>>> old mode 100644
>>>>> new mode 100755
>>>>> index 9e829fda2e..ecc35db528
>>>>> --- a/scripts/update-aarch64-cpu-sysreg-properties.py
>>>>> +++ b/scripts/update-aarch64-cpu-sysreg-properties.py
>>>>> @@ -106,6 +106,29 @@ def collect_fields(item, bit_offset=0):
>>>>>
>>>>>    return fields
>>>>>
>>>>> +def parse_value_int(raw_val):
>>>>> +    if raw_val is None or isinstance(raw_val, bool):
>>>>> +        return None
>>>>> +
>>>>> +    # may already be real number
>>>>> +    if isinstance(raw_val, int):
>>>>> +        return raw_val
>>>>> +
>>>>> +    raw_str = str(raw_val).strip()
>>>>> +
>>>>> +    if "'" in raw_str:
>>>>> +        # quoted bitstring like "'0100'"
>>>>> +        bits = raw_str.replace("'", "")
>>>>> +        try:
>>>>> +            return int(bits, 2)
>>>>> +        except ValueError:
>>>>> +            return None
>>>>> +
>>>>> +    # unquoted, try decimal
>>>>> +    try:
>>>>> +        return int(raw_str, 0)
>>>>> +    except ValueError:
>>>>> +        return None
>>>>>
>>>>> def extract_field_enums(field):
>>>>>    enums = []
>>>>> @@ -124,32 +147,23 @@ def extract_field_enums(field):
>>>>>    if not isinstance(val_entries, list):
>>>>>        return enums
>>>>>
>>>>> +    # A Values.ValueRange field specifies start and end value for a range.
>>>>> +    # Don't enumerate anything for them.
>>>>> +    for val_entry in val_entries:
>>>>> +        if isinstance(val_entry, dict) and \
>>>>> +           val_entry.get("_type") == "Values.ValueRange":
>>>>> +               return []
>>>>> +
>>>>>    for val_entry in val_entries:
>>>>>        if not isinstance(val_entry, dict):
>>>>>            continue
>>>>> -            
>>>>> +
>>>>>        if val_entry.get("_type") == "Values.Value":
>>>>> -            raw_val = val_entry.get("value")
>>>>> -            if raw_val is None:
>>>>> +            int_val = parse_value_int(val_entry.get("value"))
>>>>> +            if int_val is None:
>>>>>                continue
>>>>> -                
>>>>> -            # some of the values have ' like "'0100'"
>>>>> -            raw_val_str = str(raw_val).strip().replace("'", "")
>>>>> -            
>>>>> -            try:
>>>>> -                # convert into bin 
>>>>> -                int_val = int(raw_val_str, 2)
>>>>> -            except ValueError:
>>>>> -                try:
>>>>> -                    # Fallback to dec if not bin
>>>>> -                    int_val = int(raw_val_str, 0)
>>>>> -                except ValueError:
>>>>> -                    continue
>>>>> -            
>>>>> -            enums.append({
>>>>> -                'value': int_val
>>>>> -            })
>>>>> -            
>>>>> +            enums.append({'value': int_val})
>>>>> +
>>>>>    return enums
>>>>>
>>>>> def generate_sysreg_properties_from_registers_json(id_reg_names, raw_json_path):
>>>>> @@ -210,7 +224,7 @@ def generate_sysreg_properties_from_registers_json(id_reg_names, raw_json_path):
>>>>>                       msb > current_fieldset_fields[unique_key]['msb']:
>>>>>                        enums = extract_field_enums(val)
>>>>>                        current_fieldset_fields[unique_key] = {
>>>>> -                            'raw_name': name,
>>>>> +                            'raw_name': unique_key,
>>>>>                            'lsb': lsb,
>>>>>                            'msb': msb,
>>>>>                            'width': width,
>>>>> @@ -238,6 +252,15 @@ def generate_sysreg_properties_from_registers_json(id_reg_names, raw_json_path):
>>>>>        # Sort decreasing lsbs
>>>>>        sorted_fields = sorted(unique_fields.items(),
>>>>>                               key=lambda x: x[1]['lsb'], reverse=True)
>>>>> +        if len(sorted_fields) == 0:
>>>>> +            # cases like REVIDR_EL1 and AIDR_EL1.
>>>>> +            # augment a dummy fields VAL.
>>>>> +            sorted_fields.append(('VAL', {
>>>>> +                'lsb': 0,
>>>>> +                'msb': 63,
>>>>> +                'width': 64,
>>>>> +                'enums': []
>>>>> +            }))
>>>>>
>>>>>        for unique_key, bits in sorted_fields:
>>>>>            enums_list = bits.get('enums', [])
>

