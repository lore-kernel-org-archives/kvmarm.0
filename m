Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792608036;
	b=h2hj0Q60ZFteTRghqZJvF5whg1P7HX71wcEGwooVXnfzx+f8Yv8+SgwXf0I6yOp60X25
	 tKVRs11Ajkc2EtHmsUZcsZ4aDItRf4LE2gX4yEH3GWdHB5PvBOcVjC5MavzmwHqTP7Zqc
	 qcajuf1+PvElJppFJl2lEO/IG0BgLBviQSoOHrtOC1kf0rIAMTOBexqFC+9XUF/UcAux6
	 5o9wDHhK81DYq5bd87QgFV+7q26YULANtRmL9FGRmQmRYpPFKuEBdixdOCB2NdyfPECSN
	 Xxssf2xVTy/Jmc46I/w26HowVxQDTQUt2vNbVkKDOpTtYZdHAQ8JOoywzeGq2Mtz7ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792608036;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=BitS6b6GmJtVbIbbwCjbeh5dxwaM3lS49abzdXtNPts=;
	b=CjGO2pTUmyn3IClgjAa1BHKeBuNYy/YNLC6mdVe/rmNyK6OQLwomFF5J1ga+Gc4SWuHv
	 xsXIsscznYIJNMnTnMKaZ2zBaepqlPZDq2qv/7mZdTtzO7yRxX81AP5OPIzgLLfdGfAqD
	 j9iaAukbKkbTfElu6jajefSScx7Zd8GImG7xzgxtz6jMRKMbQBmP7lMaqwlHFKRUgfQr0
	 QrmI8PtkuFP7G+GfWWjEeZoT/LFcoSQM8MR1OFjQPjvAMLwKOICNv0LC3hWlFMrPhtvrA
	 /snPgScZsCElw5MKNbP1QBNpqOaQlaaCgqPmDzNVjW0dmecDbkErQqaPC9fIEdd2unw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=tT3gz+Cd;
	arc=none smtp.remote-ip=209.85.218.72
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E79606A31F
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 18:40:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3E79606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=tT3gz+Cd
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c42f98f351eso113914666b.0
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 11:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792608033; x=1793212833; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BitS6b6GmJtVbIbbwCjbeh5dxwaM3lS49abzdXtNPts=;
        b=tT3gz+CdJTAoJ/Q9sSxrg7dHhbpFBy6gATDnrgELzHTc9w8jJLAsdgsrZe/y/tqUq7
         EgRay1bJ6oHIqGHmpFXSpnpyrKIKG9T95+jRI/cSbSRCDZpCdCIHS/oY/oXoFOE4IAt/
         RLqcTjkLs6uDafRfPRxttjMtvZ3ikvY0ScYJqpJxIANc8R+PJkGfjB3I6Z42hV3sO4kh
         +hpUyYuKAy71mPZ+GYXEgb6ai+AAQtB3SIKWGwdA58fBQMP+ly8dM4/vJXOswXTWnyfH
         wg4nEZSe8MBicBSkUGrXJ4SnaVIx+wBlUAdtJB/qc6Ht8SsPdvcoH9/0L8K7RIyuoPt4
         unNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792608033; x=1793212833;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BitS6b6GmJtVbIbbwCjbeh5dxwaM3lS49abzdXtNPts=;
        b=ZdEFOL/w3wnZJMcY0Kb3nUiqyDcGey7CT+6cmjxaV4fxryVMVS281Lrk5EoJQqXlfO
         XqOrih3AhCQprMEJknT2r3lIisawNUkhYH38/0lCVTCfHPfV6MjUppZHYy1hdrIqxJjD
         h/M/nfpSELvRrQ5vkyHIolgvtoIZ0T4jnp5NjTUZ9EyZAREKI7t7bIktZbb063ryw/2v
         Q/C3AgvpRLQsWPT92khKEk40R2v4Qlu56pw/hzFtzLuBrOTEfxOKYUqobadsuFRWqlca
         lCzdiuiMx0sj8PIQp1Ka+CI4ZGzDoUaECT9UTW+0+orgXbHvfE8M8jOfssojCTmkkiqf
         6rNw==
X-Forwarded-Encrypted: i=1; AKwUvBxChRM3TXEi07/7dsVy+D99iRnKGxkn2Wper/fvQDU8YjYJPEHLyCFpz5vGRg2jQtIt9KWtQQY=@lists.linux.dev
X-Gm-Message-State: AFq9FYIThXc8Fix8D1z2q/gw0Gmxx9oRT/UuIPRae2PDfeaKFbv8G43a
	lSMF1+ndD3f/pjEcTZfROwpwhZOhswCADjmDDgZxt2BBZwPvL3Sy2koShLX8UxSKUl7A9l8NcGd
	ArhMLM3gjPB9N1+FIHw==
X-Received: from ejbjp16.prod.google.com ([2002:a17:906:f750:b0:c3f:c35a:7704])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:7308:b0:c32:414:b72c with SMTP id a640c23a62f3a-c467974612cmr239885366b.45.1792608032415;
 Wed, 21 Oct 2026 11:40:32 -0700 (PDT)
Date: Wed, 21 Oct 2026 18:40:31 +0000
In-Reply-To: <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-4-tarunsahu@google.com>
 <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com>
Message-ID: <9huzecdi6go0.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
From: tarunsahu@google.com
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	David Matlack <dmatlack@google.com>, jgg@nvidia.com, robin.murphy@arm.com, 
	loganodell@google.com, oupton@kernel.org, kevin.tian@intel.com, 
	alex@shazbot.org, dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, 
	will@kernel.org, Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	baolu.lu@linux.intel.com, linux-arm-kernel@lists.infradead.org, 
	linux-arch@vger.kernel.org, sagis@google.com, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev, linux-pci@vger.kernel.org, 
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Pasha Tatashin <pasha.tatashin@soleen.com> writes:

> On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <tarunsahu@google.com=
> wrote:
>>
>> LUO and its file handlers validate handed-over state with monolithic
>> compatibility strings ("luo-v5", "memfd-v2"). Any change to a serialized
>> structure, even an optional additive one, must bump the string, which
>> breaks live update between adjacent kernels. Replace the string in
>> struct luo_ser with a feature header, so that the target kernel can
>> accept or reject the source kernel state per feature.
>>
>> struct luo_feature_hdr is a fixed 128-byte header: the serialized
>
> This patch is all wrong; 128 bytes is far too large. For every _ser
> struct, we only need 8 bytes instead.

NOO, It is not. It is intended to avoid complex mess with unnecessary
over-engineering.

>
> The first 4 bytes are the size, and the next 4 bytes are flags (i.e.,
> 30 feature flags + 2 reserved bits for flags extension). The last two
> bits of the flags indicate whether an extended flags field is present.
> Each extended flags field is 8 bytes, and its last two bits indicate
> that yet another extended flags field follows.

If we will have dynamic extension of flags, Think about this.

Source Kernel:
struct ser_ABI {
       struct luo_feature_hdr features; // 8 bytes
       type1 field1;
       type2 field2;
       type3 field3[I_AM_ARRAY];
}

Target Kernel:
struct ser_ABI {
       struct luo_feature_hdr features; // 12 bytes
       type1 field1;
       type2 field2; // this feature is deprecated and optional
       type3 field3[I_AM_ARRAY];
       type4 field4; // this is new feature
}


Deserialization in target kernel:
Direct Casting is impossible!!


- First It will validate the features. Done!
- Get a start_size variable initialized to 0.
- Then it will caclucalte the header size to know where the next field
  in ser_ABI structure starts at. start_size +=3D sizeof(features) Ohh!
  this is wrong, so start_size +=3D sizeof(payload->features) But there is
  no way to directly know the size of payload->features as direct
  casting cant be done with target kernel structure. So count the flags
  in the payload feature based on EXTENSION Bit set. start_size +=3D
  calculated_payload_features_size
- now cast this new location with type1 field1 =3D copy of the (type1)start=
_size;
- now start_size +=3D sizeof(type1)

And So On! And direct casting is not possible so we will be doing
memcpy (performance regression)

this is how every subsytem will implement their retrieval
function. Very messy and I am completely against it. It will become more
complex when rollback will be considered in this situation as well.

Here is the example of rollback,


Source Kernel:
struct ser_ABI {
       struct luo_feature_hdr features; // 12 bytes
       type1 field1;
       type2 field2; // this feature is deprecated and optional
       type3 field3[I_AM_ARRAY];
       type4 field4; // this is new feature
}

Target Kernel:
struct ser_ABI {
       struct luo_feature_hdr features; // 8 bytes
       type1 field1;
       type2 field2;
       type3 field3[I_AM_ARRAY];
}


Deserialization in target kernel.

Calculate the payload features size, then get the address of the field1
cast it with type1 (you can get the type1 from target kernel ser_ABI)
then you move to field2 which is optional. So again add its size and get
address of field3 then cast it and load the data and move to next field
by adding the size of the array* sizeof(type3), As direct casting is not
possible so we will be doing memcpy (performance regression).

~Tarun


>
>> structure size from the source kernel followed by 15 chained u64 feature
>> flags entries. The fixed size keeps payload field offsets identical in
>> every kernel, regardless of how many flags entries a source kernel uses.
>>
>> Each feature has a 2-bit pair (req, active) state (enum luo_feat_state:
>> LUO_FEAT_DISABLED, LUO_FEAT_OPTIONAL, LUO_FEAT_REQUIRED). A flags entry
>> holds 31 features, and bits [63:62] =3D 0b11 chain to the next entry (46=
5
>> features in total). Each subsystem defines its feature states as a
>> static const u8 array indexed by its feature enum, which
>> luo_feature_hdr_init() packs into 64-bit flags entries with
>> LUO_FEAT_EXT_MASK chain bits. The target kernel validates the header fro=
m
>> the source kernel against its own feature array via
>> luo_feature_hdr_validate() according to the per-feature (req, active)
>> truth table:
>>
>>   Source Target Action
>>   (1,0)  (x,x)  Reject -EINVAL: invalid source kernel (req without activ=
e)
>>   (x,x)  (1,0)  Reject -EINVAL + WARN_ON_ONCE: invalid target kernel
>>   (0,0)  (0,0)  Accept: feature absent
>>   (0,0)  (0,1)  Accept: feature absent
>>   (0,0)  (1,1)  Reject -EOPNOTSUPP: target kernel requires the feature
>>   (0,1)  (0,0)  Accept: ignore payload data
>>   (1,1)  (0,0)  Reject -EOPNOTSUPP: source kernel requires the feature
>>   (x,1)  (x,1)  Accept: use payload data
>>
>> The relative order and offsets of fields in serialized structures must
>> remain unchanged as features are added or retired. New fields are always
>> appended at the end of the structure under a new feature flag, and
>> retired fields are kept in place so that the offsets of subsequent
>> fields never shift. If the type or format of a field needs to change, th=
e
>> existing field and feature are kept intact (and retired when no longer
>> needed) and a new feature flag with a new appended field of the new type
>> is added.
>>
>> In the target kernel, fields of a LUO_FEAT_REQUIRED feature are
>> guaranteed to be present once luo_feature_hdr_validate() succeeds,
>> whereas fields of a LUO_FEAT_OPTIONAL feature should be accessed only
>> after verifying that the feature is active in the source kernel header:
>>
>>   if (luo_feature_is_active(&ser->features, FEAT_X))
>>           val =3D ser->x_field;
>>
>> All current struct luo_ser fields (liveupdate_num, sessions_pa, flbs_pa)
>> belong to LUO_CORE_FEAT_CORE (LUO_FEAT_REQUIRED in luo_core_features).
>> Future changes add new entries to enum luo_core_feature before
>> LUO_CORE_FEAT_MAX.
>>
>> Signed-off-by: Logan Odell <loganodell@google.com>
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>> ---
>>  include/linux/kho/abi/luo.h  | 345 +++++++++++++++++++++++++++++++----
>>  kernel/liveupdate/luo_core.c |  27 ++-
>>  2 files changed, 332 insertions(+), 40 deletions(-)
>>
>> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
>> index 5fb2f46425d7..be35cfbfdb2b 100644
>> --- a/include/linux/kho/abi/luo.h
>> +++ b/include/linux/kho/abi/luo.h
>> @@ -9,19 +9,53 @@
>>   * DOC: Live Update Orchestrator ABI
>>   *
>>   * Live Update Orchestrator uses the stable Application Binary Interfac=
e
>> - * defined below to pass state from a pre-update kernel to a post-updat=
e
>> - * kernel. The ABI is built upon the Kexec HandOver framework and regis=
ters
>> - * the central `struct luo_ser` via the KHO raw subtree API.
>> + * defined below to pass state from a source kernel to a target kernel.
>> + * The ABI is built upon the Kexec HandOver framework and registers the
>> + * central `struct luo_ser` via the KHO raw subtree API.
>>   *
>> - * This interface is a contract. Any modification to the structure fiel=
ds,
>> - * compatible strings, or the layout of the `__packed` serialization
>> - * structures defined here constitutes a breaking change. Such changes =
require
>> - * incrementing the version number in the relevant `_COMPATIBLE` string=
 to
>> - * prevent a new kernel from misinterpreting data from an old kernel.
>> + * This interface is a contract. Serialized structures start with a fix=
ed
>> + * 128-byte feature header (`struct luo_feature_hdr`) holding the sourc=
e
>> + * kernel's structure `size` and 15 chained 64-bit feature flags entrie=
s
>> + * (`flags[LUO_FEAT_NR_FLAGS]`). Each entry encodes up to 31 features a=
s
>> + * 2-bit `0b<req><active>` pairs (`enum luo_feat_state`), with
>> + * `LUO_FEAT_EXT_MASK` in bits `[63:62]` chaining to the next entry (up=
 to
>> + * 465 features total). Because the header size is fixed at 128 bytes,
>> + * payload field offsets do not depend on how many flags entries a sour=
ce
>> + * kernel uses.
>>   *
>> - * Changes are allowed provided the compatibility version is incremente=
d;
>> - * however, backward/forward compatibility is only guaranteed for kerne=
ls
>> - * supporting the same ABI version.
>> + * Truth table (`(req,active)` pairs per feature)::
>> + *
>> + *   Source Target Action
>> + *   (1,0)  (x,x)  Reject -EINVAL: invalid source kernel (req without a=
ctive)
>> + *   (x,x)  (1,0)  Reject -EINVAL: invalid target kernel (req without a=
ctive)
>> + *   (0,0)  (0,0)  Accept: feature absent
>> + *   (0,0)  (0,1)  Accept: feature absent
>> + *   (0,0)  (1,1)  Reject -EOPNOTSUPP: target kernel requires the featu=
re
>> + *   (0,1)  (0,0)  Accept: ignore payload data
>> + *   (1,1)  (0,0)  Reject -EOPNOTSUPP: source kernel requires the featu=
re
>> + *   (x,1)  (x,1)  Accept: use payload data
>> + *
>> + * The relative order and offsets of fields in serialized structures mu=
st
>> + * remain unchanged as features are added or retired. New fields are al=
ways
>> + * appended at the end of the structure under a new feature flag, and
>> + * retired fields are kept in place so that the offsets of subsequent
>> + * fields never shift. If a field's type or format needs to change, the
>> + * existing field and feature are kept intact (and retired when no long=
er
>> + * needed) and a new feature flag with a new appended field of the new =
type
>> + * is added.
>> + *
>> + * In the target kernel, fields of a `LUO_FEAT_REQUIRED` feature are
>> + * guaranteed to be present once `luo_feature_hdr_validate()` succeeds,
>> + * whereas fields of a `LUO_FEAT_OPTIONAL` feature should be accessed o=
nly
>> + * after verifying that the feature is active in the source kernel's he=
ader::
>> + *
>> + *   if (luo_feature_is_active(&ser->features, FEAT_X))
>> + *           val =3D ser->x_field;
>> + *
>> + * All current `struct luo_ser` fields (`liveupdate_num`, `sessions_pa`=
,
>> + * `flbs_pa`) belong to `LUO_CORE_FEAT_CORE` (`LUO_FEAT_REQUIRED` in
>> + * `luo_core_features`). Future changes add new entries to
>> + * `enum luo_core_feature` before `LUO_CORE_FEAT_MAX`.
>>   *
>>   * KHO Structure Overview:
>>   *   The entire LUO state is encapsulated within a single KHO entry nam=
ed "LUO".
>> @@ -30,8 +64,9 @@
>>   * Serialization Structures:
>>   *   - struct luo_ser:
>>   *     The central ABI structure that contains the overall state of the=
 LUO.
>> - *     It includes the compatibility string, the liveupdate-number, and=
 pointers
>> - *     to sessions and FLBs.
>> + *     It includes the feature header (with struct size and 2-bit featu=
re flag
>> + *     pairs), and the core feature (`LUO_CORE_FEAT_CORE`) fields: the
>> + *     liveupdate-number and pointers to sessions and FLBs.
>>   *
>>   *   - struct luo_session_ser:
>>   *     Metadata for a single session, including its name and a physical=
 pointer
>> @@ -40,8 +75,9 @@
>>   *
>>   *   - struct luo_file_ser:
>>   *     Metadata for a single preserved file. Contains the handler `name=
` string
>> - *     to find the correct handler in the new kernel, a user-provided `=
token`
>> - *     for identification, and an opaque `data` handle for the handler =
to use.
>> + *     to find the correct handler in the target kernel, a user-provide=
d
>> + *     `token` for identification, and an opaque `data` handle for the =
handler
>> + *     to use.
>>   *
>>   *   - struct luo_flb_header_ser:
>>   *     Header for the FLB array. Contains the total page count of the
>> @@ -57,20 +93,265 @@
>>  #ifndef _LINUX_KHO_ABI_LUO_H
>>  #define _LINUX_KHO_ABI_LUO_H
>>
>> -#include <linux/align.h>
>> +#include <linux/array_size.h>
>> +#include <linux/bits.h>
>> +#include <linux/bug.h>
>> +#include <linux/build_bug.h>
>> +#include <linux/errno.h>
>>  #include <linux/kho/abi/block.h>
>> +#include <linux/types.h>
>>  #include <uapi/linux/liveupdate.h>
>>
>>  /*
>>   * The LUO state is registered under this KHO entry name.
>>   */
>>  #define LUO_KHO_ENTRY_NAME     "LUO"
>> -#define LUO_ABI_COMPATIBLE     "luo-v5"
>> -#define LUO_ABI_COMPAT_LEN     ALIGN(sizeof(LUO_ABI_COMPATIBLE), 8)
>> +
>> +#define LUO_FEAT_PER_FLAGS     31
>> +#define LUO_FEAT_NR_FLAGS      15
>> +#define LUO_FEAT_MAX           (LUO_FEAT_NR_FLAGS * LUO_FEAT_PER_FLAGS)
>> +#define LUO_FEAT_EXT_MASK      GENMASK_ULL(63, 62)
>> +#define LUO_FEAT_ACTIVE_MASK   (0x5555555555555555ULL & ~LUO_FEAT_EXT_M=
ASK)
>> +#define LUO_FEAT_REQ_MASK      (0xaaaaaaaaaaaaaaaaULL & ~LUO_FEAT_EXT_M=
ASK)
>> +
>> +#define LUO_FEAT_FLAGS_IDX(f)  ((unsigned int)(f) / LUO_FEAT_PER_FLAGS)
>> +#define LUO_FEAT_SLOT(f)       ((unsigned int)(f) % LUO_FEAT_PER_FLAGS)
>> +
>> +#define LUO_FEAT_ACTIVE(f)     BIT_ULL(2 * LUO_FEAT_SLOT(f))
>> +#define LUO_FEAT_REQ(f)                BIT_ULL(2 * LUO_FEAT_SLOT(f) + 1=
)
>> +
>> +/**
>> + * enum luo_feat_state - 2-bit state of a LUO feature (`0b<req><active>=
`).
>> + * @LUO_FEAT_DISABLED: Feature is inactive (`req=3D0, active=3D0`).
>> + * @LUO_FEAT_OPTIONAL: Feature is active and optional (`req=3D0, active=
=3D1`).
>> + * @LUO_FEAT_REQUIRED: Feature is active and required (`req=3D1, active=
=3D1`).
>> + */
>> +enum luo_feat_state {
>> +       LUO_FEAT_DISABLED =3D 0b00,
>> +       LUO_FEAT_OPTIONAL =3D 0b01,
>> +       LUO_FEAT_REQUIRED =3D 0b11,
>> +};
>> +
>> +/**
>> + * struct luo_feature_hdr - Fixed 128-byte header for serialized LUO AB=
I structures.
>> + * @size:  Size in bytes of the source kernel's enclosing serialized st=
ructure.
>> + * @flags: Chained 64-bit feature flags entries (`0 .. LUO_FEAT_NR_FLAG=
S - 1`).
>> + *         Each entry holds 31 2-bit feature pairs (`[2*slot + 1 : 2*sl=
ot]`)
>> + *         plus %LUO_FEAT_EXT_MASK in bits `[63:62]` when the next entr=
y is
>> + *         active.
>> + */
>> +struct luo_feature_hdr {
>> +       u64 size;
>> +       u64 flags[LUO_FEAT_NR_FLAGS];
>> +} __packed;
>
>
>> +
>> +static_assert(sizeof(struct luo_feature_hdr) =3D=3D 128);
>> +
>> +/**
>> + * luo_feature_hdr_for_each_flags - Iterate over chained flags entries =
in @hdr.
>> + * @hdr: Pointer to the &struct luo_feature_hdr to iterate.
>> + * @idx: Loop cursor of type `unsigned int` (`0 .. LUO_FEAT_NR_FLAGS - =
1`).
>> + */
>> +#define luo_feature_hdr_for_each_flags(hdr, idx)                       =
\
>> +       for ((idx) =3D 0; (idx) < LUO_FEAT_NR_FLAGS;                    =
  \
>> +            (idx) =3D (((hdr)->flags[idx] & LUO_FEAT_EXT_MASK) =3D=3D  =
      \
>> +                     LUO_FEAT_EXT_MASK) ? (idx) + 1 : LUO_FEAT_NR_FLAGS=
)
>> +
>> +/**
>> + * luo_feature_hdr_get_flags - Get the flags entry containing feature @=
feat.
>> + * @hdr:  Pointer to the source kernel's feature header.
>> + * @feat: Feature index (`0 .. LUO_FEAT_MAX - 1`).
>> + *
>> + * Return: The u64 flags entry containing @feat if the extension chain =
reaches
>> + *         it, or 0 otherwise.
>> + */
>> +static inline u64
>> +luo_feature_hdr_get_flags(const struct luo_feature_hdr *hdr,
>> +                         unsigned int feat)
>> +{
>> +       unsigned int target_idx =3D LUO_FEAT_FLAGS_IDX(feat);
>> +       unsigned int idx;
>> +
>> +       if (target_idx >=3D LUO_FEAT_NR_FLAGS)
>> +               return 0;
>> +
>> +       luo_feature_hdr_for_each_flags(hdr, idx) {
>> +               if (idx =3D=3D target_idx)
>> +                       return hdr->flags[idx];
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +/**
>> + * luo_feature_is_active - Test whether feature @feat is active in @hdr=
.
>> + * @hdr:  Pointer to the source kernel's feature header.
>> + * @feat: Feature index (`0 .. LUO_FEAT_MAX - 1`).
>> + *
>> + * Return: true if the source kernel marked @feat active, false otherwi=
se.
>> + */
>> +static inline bool luo_feature_is_active(const struct luo_feature_hdr *=
hdr,
>> +                                        unsigned int feat)
>> +{
>> +       return luo_feature_hdr_get_flags(hdr, feat) & LUO_FEAT_ACTIVE(fe=
at);
>> +}
>> +
>> +/**
>> + * luo_feature_is_req - Test whether feature @feat is required in @hdr.
>> + * @hdr:  Pointer to the source kernel's feature header.
>> + * @feat: Feature index (`0 .. LUO_FEAT_MAX - 1`).
>> + *
>> + * Return: true if the source kernel marked @feat required, false other=
wise.
>> + */
>> +static inline bool luo_feature_is_req(const struct luo_feature_hdr *hdr=
,
>> +                                     unsigned int feat)
>> +{
>> +       return luo_feature_hdr_get_flags(hdr, feat) & LUO_FEAT_REQ(feat)=
;
>> +}
>> +
>> +/**
>> + * luo_feature_pack_entry - Pack up to 31 feature states into a flags e=
ntry.
>> + * @features:    Array of &enum luo_feat_state values indexed by featur=
e ID.
>> + * @nr_features: Number of elements in @features.
>> + * @idx:         Flags entry index (`0 .. LUO_FEAT_NR_FLAGS - 1`).
>> + *
>> + * Return: The packed 64-bit flags entry for @idx (without %LUO_FEAT_EX=
T_MASK).
>> + */
>> +static inline u64
>> +luo_feature_pack_entry(const u8 *features, size_t nr_features,
>> +                      unsigned int idx)
>> +{
>> +       unsigned int base =3D idx * LUO_FEAT_PER_FLAGS;
>> +       unsigned int slot;
>> +       u64 flags =3D 0;
>> +
>> +       for (slot =3D 0; slot < LUO_FEAT_PER_FLAGS && base + slot < nr_f=
eatures;
>> +            slot++)
>> +               flags |=3D (u64)(features[base + slot] & 0b11) << (2 * s=
lot);
>> +
>> +       return flags;
>> +}
>> +
>> +/**
>> + * __luo_feature_hdr_init - Initialize a serialized LUO feature header.
>> + * @hdr:         Pointer to the feature header to initialize.
>> + * @size:        Byte size of the enclosing serialized structure.
>> + * @features:    Array of &enum luo_feat_state values for the source ke=
rnel.
>> + * @nr_features: Number of elements in @features (`<=3D LUO_FEAT_MAX`).
>> + */
>> +static inline void
>> +__luo_feature_hdr_init(struct luo_feature_hdr *hdr, u64 size,
>> +                      const u8 *features, size_t nr_features)
>> +{
>> +       bool ext =3D false;
>> +       int idx;
>> +
>> +       hdr->size =3D size;
>> +       for (idx =3D LUO_FEAT_NR_FLAGS - 1; idx >=3D 0; idx--) {
>> +               u64 flags =3D luo_feature_pack_entry(features, nr_featur=
es, idx);
>> +
>> +               WARN_ON_ONCE(((flags & LUO_FEAT_REQ_MASK) >> 1) &
>> +                            ~(flags & LUO_FEAT_ACTIVE_MASK));
>> +               if (ext)
>> +                       flags |=3D LUO_FEAT_EXT_MASK;
>> +               else if (flags)
>> +                       ext =3D true;
>> +               hdr->flags[idx] =3D flags;
>> +       }
>> +}
>> +
>> +/**
>> + * luo_feature_hdr_init - Initialize a serialized LUO feature header.
>> + * @hdr:      Pointer to the feature header to initialize.
>> + * @size:     Byte size of the enclosing serialized structure.
>> + * @features: Fixed-size `u8` array of &enum luo_feat_state entries.
>> + */
>> +#define luo_feature_hdr_init(hdr, size, features)                      =
\
>> +({                                                                     =
\
>> +       BUILD_BUG_ON(ARRAY_SIZE(features) > LUO_FEAT_MAX);              =
\
>> +       __luo_feature_hdr_init(hdr, size, features,                     =
\
>> +                              ARRAY_SIZE(features));                   =
\
>> +})
>> +
>> +/**
>> + * __luo_feature_hdr_validate - Validate a source kernel's LUO feature =
header
>> + *                              against the target kernel's feature arr=
ay.
>> + * @hdr:         Pointer to the feature header from the source kernel.
>> + * @features:    Array of &enum luo_feat_state values for the target ke=
rnel.
>> + * @nr_features: Number of elements in @features (`<=3D LUO_FEAT_MAX`).
>> + *
>> + * Return: 0 if compatible, -EINVAL on malformed header or `(req=3D1, a=
ctive=3D0)`
>> + *         feature state, or -EOPNOTSUPP on required feature mismatch.
>> + */
>> +static inline int
>> +__luo_feature_hdr_validate(const struct luo_feature_hdr *hdr,
>> +                          const u8 *features, size_t nr_features)
>> +{
>> +       bool src_ext =3D true, target_ext =3D (nr_features > 0);
>> +       unsigned int idx;
>> +
>> +       if (hdr->size < sizeof(*hdr))
>> +               return -EINVAL;
>> +
>> +       for (idx =3D 0; idx < LUO_FEAT_NR_FLAGS && (src_ext || target_ex=
t); idx++) {
>> +               u64 src =3D src_ext ? hdr->flags[idx] : 0;
>> +               u64 target =3D target_ext ?
>> +                       luo_feature_pack_entry(features, nr_features, id=
x) : 0;
>> +               u64 ext =3D src & LUO_FEAT_EXT_MASK;
>> +               u64 src_act =3D src & LUO_FEAT_ACTIVE_MASK;
>> +               u64 src_req =3D (src & LUO_FEAT_REQ_MASK) >> 1;
>> +               u64 target_act =3D target & LUO_FEAT_ACTIVE_MASK;
>> +               u64 target_req =3D (target & LUO_FEAT_REQ_MASK) >> 1;
>> +
>> +               if (ext && (ext !=3D LUO_FEAT_EXT_MASK ||
>> +                           idx =3D=3D LUO_FEAT_NR_FLAGS - 1))
>> +                       return -EINVAL;
>> +               if (src_req & ~src_act)
>> +                       return -EINVAL;
>> +               if (WARN_ON_ONCE(target_req & ~target_act))
>> +                       return -EINVAL;
>> +               if ((src_req & ~target_act) || (target_req & ~src_act))
>> +                       return -EOPNOTSUPP;
>> +
>> +               src_ext =3D (ext =3D=3D LUO_FEAT_EXT_MASK);
>> +               target_ext =3D ((idx + 1) * LUO_FEAT_PER_FLAGS < nr_feat=
ures);
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +/**
>> + * luo_feature_hdr_validate - Validate a source kernel's LUO feature he=
ader
>> + *                            against the target kernel's feature array=
.
>> + * @hdr:      Pointer to the feature header from the source kernel.
>> + * @features: Fixed-size `u8` array of &enum luo_feat_state entries.
>> + *
>> + * Return: 0 if compatible, -EINVAL on malformed header or feature stat=
e, or
>> + *         -EOPNOTSUPP on required feature mismatch.
>> + */
>> +#define luo_feature_hdr_validate(hdr, features)                        =
        \
>> +({                                                                     =
\
>> +       BUILD_BUG_ON(ARRAY_SIZE(features) > LUO_FEAT_MAX);              =
\
>> +       __luo_feature_hdr_validate(hdr, features,                       =
\
>> +                                  ARRAY_SIZE(features));               =
\
>> +})
>> +
>> +/**
>> + * enum luo_core_feature - Feature indices for &struct luo_ser.
>> + * @LUO_CORE_FEAT_CORE: Core feature covering `liveupdate_num`, `sessio=
ns_pa`,
>> + *                      and `flbs_pa`.
>> + * @LUO_CORE_FEAT_MAX:  Number of defined &enum luo_core_feature featur=
es.
>> + */
>> +enum luo_core_feature {
>> +       LUO_CORE_FEAT_CORE =3D 0,
>> +       LUO_CORE_FEAT_MAX,
>> +};
>> +
>> +static_assert((int)LUO_CORE_FEAT_MAX <=3D LUO_FEAT_MAX);
>>
>>  /**
>>   * struct luo_ser - Centralized LUO ABI header.
>> - * @compatible:     Compatibility string identifying the LUO ABI versio=
n.
>> + * @features:       ABI feature and size header for luo_ser.
>>   * @liveupdate_num: A counter tracking the number of successful live up=
dates.
>>   * @sessions_pa:    Physical address of the first session block header.
>>   * @flbs_pa:        Physical address of the FLB header.
>> @@ -78,7 +359,7 @@
>>   * This structure is the root of all preserved LUO state.
>>   */
>>  struct luo_ser {
>> -       char compatible[LUO_ABI_COMPAT_LEN];
>> +       struct luo_feature_hdr features;
>>         u64 liveupdate_num;
>>         u64 sessions_pa;
>>         u64 flbs_pa;
>> @@ -90,7 +371,7 @@ struct luo_ser {
>>   * @data:        Private data
>>   * @token:       User provided token for this file
>>   *
>> - * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
>> + * Layout changes must be gated by a required feature in &enum luo_core=
_feature.
>>   */
>>  struct luo_file_ser {
>>         char name[LIVEUPDATE_HNDL_NAME_LENGTH];
>> @@ -121,10 +402,10 @@ struct luo_file_set_ser {
>>   *
>>   * This structure is used to package session-specific metadata for tran=
sfer
>>   * between kernels via Kexec Handover. An array of these structures (on=
e per
>> - * session) is created and passed to the new kernel, allowing it to rec=
onstruct
>> - * the session context.
>> + * session) is created and passed to the target kernel, allowing it to
>> + * reconstruct the session context.
>>   *
>> - * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
>> + * Layout changes must be gated by a required feature in &enum luo_core=
_feature.
>>   */
>>  struct luo_session_ser {
>>         char name[LIVEUPDATE_SESSION_NAME_LENGTH];
>> @@ -145,7 +426,7 @@ struct luo_session_ser {
>>   * This structure is located at the physical address specified by the
>>   * flbs_pa in luo_ser.
>>   *
>> - * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
>> + * Layout changes must be gated by a required feature in &enum luo_core=
_feature.
>>   */
>>  struct luo_flb_header_ser {
>>         u64 pgcnt;
>> @@ -155,19 +436,19 @@ struct luo_flb_header_ser {
>>  /**
>>   * struct luo_flb_ser - Represents the serialized state of a single FLB=
 object.
>>   * @name:    The unique name string of the FLB object, used to find the
>> - *           corresponding &struct liveupdate_flb handler in the new ke=
rnel.
>> + *           corresponding &struct liveupdate_flb in the target kernel.
>>   * @data:    The opaque u64 handle returned by the FLB's .preserve() op=
eration
>> - *           in the old kernel. This handle encapsulates the entire sta=
te needed
>> - *           for restoration.
>> + *           in the source kernel. This handle encapsulates the entire =
state
>> + *           needed for restoration.
>>   * @count:   The reference count at the time of serialization; i.e., th=
e number
>>   *           of preserved files that depended on this FLB. This is used=
 by the
>> - *           new kernel to correctly manage the FLB's lifecycle.
>> + *           target kernel to correctly manage the FLB's lifecycle.
>>   *
>>   * An array of these structures is created in a preserved memory region=
 and
>> - * passed to the new kernel. Each entry allows the LUO core to restore =
one
>> - * global, shared object.
>> + * passed to the target kernel. Each entry allows the LUO core to resto=
re
>> + * one global, shared object.
>>   *
>> - * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
>> + * Layout changes must be gated by a required feature in &enum luo_core=
_feature.
>>   */
>>  struct luo_flb_ser {
>>         char name[LIVEUPDATE_FLB_NAME_LENGTH];
>> diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
>> index 1b2bda22902d..3627a206a79c 100644
>> --- a/kernel/liveupdate/luo_core.c
>> +++ b/kernel/liveupdate/luo_core.c
>> @@ -70,6 +70,10 @@ static struct {
>>         u64 liveupdate_num;
>>  } luo_global;
>>
>> +static const u8 luo_core_features[LUO_CORE_FEAT_MAX] =3D {
>> +       [LUO_CORE_FEAT_CORE] =3D LUO_FEAT_REQUIRED,
>> +};
>> +
>>  /*
>>   * luo_register_rwlock - Protects registration of file handlers and FLB=
s.
>>   */
>> @@ -107,15 +111,21 @@ static int __init luo_early_startup(void)
>>                 return 0;
>>         }
>>
>> -       if (len < sizeof(*luo_ser)) {
>> -               pr_err("LUO state is too small (%zu < %zu)\n", len, size=
of(*luo_ser));
>> -               return -EINVAL;
>> +       luo_ser =3D phys_to_virt(luo_ser_phys);
>> +       if (len < sizeof(luo_ser->features) || luo_ser->features.size > =
len) {
>> +               pr_err("LUO state size invalid (source kernel header siz=
e=3D%llu, KHO len=3D%zu)\n",
>> +                      len >=3D sizeof(luo_ser->features) ? luo_ser->fea=
tures.size : 0,
>> +                      len);
>> +               err =3D -EINVAL;
>> +               goto out_free_ser;
>>         }
>>
>> -       luo_ser =3D phys_to_virt(luo_ser_phys);
>> -       if (strncmp(luo_ser->compatible, LUO_ABI_COMPATIBLE, LUO_ABI_COM=
PAT_LEN)) {
>> -               pr_err("LUO state is incompatible with '%s'\n", LUO_ABI_=
COMPATIBLE);
>> -               return -EINVAL;
>> +       err =3D luo_feature_hdr_validate(&luo_ser->features, luo_core_fe=
atures);
>> +       if (err) {
>> +               pr_err("LUO state feature header validation failed (size=
=3D%llu, flags[0]=3D%#llx): %pe\n",
>> +                      luo_ser->features.size, luo_ser->features.flags[0=
],
>> +                      ERR_PTR(err));
>> +               goto out_free_ser;
>>         }
>>
>>         luo_global.liveupdate_num =3D luo_ser->liveupdate_num;
>> @@ -162,7 +172,8 @@ static int __init luo_state_setup(void)
>>                 return PTR_ERR(luo_ser);
>>         }
>>
>> -       strscpy(luo_ser->compatible, LUO_ABI_COMPATIBLE, sizeof(luo_ser-=
>compatible));
>> +       luo_feature_hdr_init(&luo_ser->features, sizeof(*luo_ser),
>> +                            luo_core_features);
>>         luo_ser->liveupdate_num =3D luo_global.liveupdate_num + 1;
>>
>>         luo_session_setup_outgoing(&luo_ser->sessions_pa);
>> --
>> 2.56.0.212.g129ede20d9-goog
>>
