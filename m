Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369C2538D75
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 11:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788952850; cv=pass; b=sHg1EdP9aIYzxKR+LckMTMVgsw8RYjn22PNs8SA8FIO8ixO1TCY/VciuxwDyst1Ra9J16QKTOcXIsIVkVWCJdDPWOPvx96i4cwbW3Mi24jxwuZNWrAW1l9R5iSydTwTxttyVS7CuBQuJIphf0XcU7t+GG2TnGpXpEW7IRsn8Tm0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788952850; c=relaxed/simple;
	bh=DGJNGDyqk/L8FuMkKQ9UZ8lh0gD+ZC6OA/bClDuW/zs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a5Vkm9C5z7SmfJSS8cFMHxlIkCK0NQ75A9OQYyyTdY/jMnNp+7Iuo1jxQ5T7bz1ebVCA3SCbsDL5Twsmtlx8R1iW3+9xXDkdAePN9qixowczRNrxSgbjl9QKLnL2vQAJ26/r6xrn3BlhUyxGiOMbP8LvE59hG6JZdG4aXQTy1TQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aLST6P6s; arc=pass smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aLST6P6s"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384c4so5888e87.1
        for <kvmarm@lists.linux.dev>; Wed, 09 Sep 2026 04:20:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788952846; cv=none;
        d=google.com; s=arc-20260327;
        b=YSKsdFe4eO8Vz9iwssi5KmTba/cB7a0CDXDHXv5dEw/QF+pUSVLD5ANHk9UeXpczJH
         bYvqGvH/80dO24MojDkCR4xx8YTfn6glfAUwGOwdmNgMeBMy4KkdK0RzXZPd1AqkUX6Q
         OtEBwuNypngHYqBn/LOrHkB3JiLuq9M7Maefs3D3LfgNIkf7zNnyjj+k14Civ18C2BbB
         AfLPv4jebI+3veD51hicbDGslgioRtU+p9XmvM5kqhrPI3ag6ktxqU2gxNT2Qd1id/1X
         rz3qe+XMOzQpfP/FPGYLR9G3h8RnbadDAT11vi6ohZauBYNPrjO8nYOjePZdfq+miaRu
         zt7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=crDfVMRTURCJ2kMvoxcTffnKsS81n5x7VpWJfYEfCY0=;
        fh=ALxBOI9E1NI7FNhLO+FD7XvsT0NTCDd/Rmm3WqFQnd4=;
        b=kzdv57J6V7Bt4/J5VzWDpRd0cyJjqu6ZvJE40wLXwprqIuJKqciHGyvnLr3x9tefr3
         rTlOCp8Q275gep1ajCthHH4+vDRmq0tqoXj8VHFLtgDA1W7WcYUDZES5xXtrks4yxyyw
         iKxpfLUcmPtFlx2KY0aHLS2FgSZdKGh8J27AQeSf+2RwOGlghRFTHyVz57xY8K6SVJkt
         4VqefyQ4Ym2wIT9JcPms68rs+BzXc8b5G3c8Bc5rxGNC3u/qZmqUWvQb0yamOowBxERR
         KH4HSszmZkOdkzETsk98/L9Hgn407nADpBAQN1+NPxtAO2zw2pmgtXcssQAOFvVpeeNh
         rNYQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788952846; x=1789557646; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=crDfVMRTURCJ2kMvoxcTffnKsS81n5x7VpWJfYEfCY0=;
        b=aLST6P6sDSJfMaEsNYNMWQ84M56STSofyFPZSALAILd3NlLX4/6Qo3uD7B7cX/B5Q8
         g+WYDJrf/Kq3/s9/uiIb0C6EahhOVzKvlBfutZ+J0iD6bjWl9oAaUe2CdAOdYGQkHvUM
         Pggzo8jC3IamvfmiBWXbXZwQ8h3lHbEnR0qm9mOkwyPnr0EOlBtUjgO4DcuPzPZgQo36
         qVVZBv78p7cLVG9CQmTXZL/QxtXvg9csCY5BPRWWKqiKMF6JoTJUCSKvNih8if4zLdJP
         NPJgVwDn5g8EgjjYeys0yL17/UUQAZvyv13hznEkdtVc/q4XeejhXltuvHG5PAGVFRXe
         QM6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788952846; x=1789557646;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=crDfVMRTURCJ2kMvoxcTffnKsS81n5x7VpWJfYEfCY0=;
        b=FVJHumvnGuVe3eeL2d5e+ACMEqI/YYZsARCmEzLADoneJlFtpbpdFeOwVqH9YvmWYD
         Y4+Xsaq2532hUV3e4RZz/+GM+W5mHn7F5ObWHSWnjxmWREyf+u+vUCu8gLs+VzizO8Hk
         WwmDGaCFbnCQ3s638hKhjNLjUxjHRP35IXxGEJSQcy6fRXq3DC50+kvec7NUhOBQESng
         ILdKe3VDA1aGllKdzchzYxyhLAO+rXCHvWuw44Cu1Aj745IzoLwNcPw3d7yFEnHEFBlU
         0iPgqNHA/6EyQjYOAKTl1WO5N6WGkhYl4ORIW/dOeX/cT/U79RVvJN9tr9it07KDDZNe
         qyCQ==
X-Forwarded-Encrypted: i=1; AKwUvBxArrmYY2gYKPVXGasuyx4DnFgFv9Jvl0uG29Y5e9YnihR1GtMHQIsuaUZ6UgFTVYkGvwrGIpE=@lists.linux.dev
X-Gm-Message-State: AFuF++kgy8xb25sGm4Q5aNi6B3AehIHnPUIRhQogZih6Le3zaxVRaOKH
	gYiA5kW91jHkKUqDARjKwOUs8s7HWFo3I6d1FYQ+8Qwug77REjhxvdf4VzulPjGrPlkfUNrBNND
	cmZGj4mx1ksmNr4Uh1o/o6A0xXmujdVqApOk8Cj54
X-Gm-Gg: AYBFou3xyCfWkSMJsLLZZkQwF7FxzyOIsiL7WczHe8n3itC2ZlpXX3sCLsqTZpi5Ox3
	kP68OsszlyA1LNQUtm+Ow8JNK7gWQooS+n07SeU1faJ7AyEfRIyAKeazDZqKGyKj/EhVMzMuN/e
	zx9QSK0UZ8X9uzdbxXOlg7LWQ5EqseA2N2tRbflnJEwh8IDyOO06np7ZdH3q6vOCbCjDf8SZQKA
	vNanQEIOkfZz4CuriuYdNKTJbK6qEBLjsYvs+dj0D+q1PAGkv+HC/KKfvAQ18ecCnn24hEgyrKT
	2OgiWflzIQ2p8qUgU4DCvvo+7kw9x2sFD5MtWADJyZ0GtTwRStXeFtLK0/OFr4yoBlk6jqMLmEe
	mV/7g2HHc85o=
X-Received: by 2002:a05:6512:3f22:b0:5b5:e890:1953 with SMTP id
 2adb3069b0e04-5b764bcde12mr149151e87.12.1788952845618; Wed, 09 Sep 2026
 04:20:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260908162223.1683432-1-suzuki.poulose@arm.com> <20260908162223.1683432-2-suzuki.poulose@arm.com>
In-Reply-To: <20260908162223.1683432-2-suzuki.poulose@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 9 Sep 2026 12:20:09 +0100
X-Gm-Features: AcwNN1UBL7PwhavrAXm1ihvLqEvgnaWmqxzjHA3KjiWz2CvXQREmUKFugkp-B-A
Message-ID: <CA+EHjTwSwGUGT=6GWaOyav7kBQey0+xpL0kJ03ABtp23ZgD6RA@mail.gmail.com>
Subject: Re: [PATCH v17 01/20] KVM: arm64: Include kvm_emulate.h in kvm/arm_psci.h
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 8 Sept 2026 at 17:22, Suzuki K Poulose <suzuki.poulose@arm.com> wro=
te:
>
> Fix a potential build error (like below, when asm/kvm_emulate.h gets
> included after the kvm/arm_psci.h) by including the missing header file
> in kvm/arm_psci.h:
>
> ./include/kvm/arm_psci.h: In function =E2=80=98kvm_psci_version=E2=80=99:
> ./include/kvm/arm_psci.h:29:13: error: implicit declaration of function
>    =E2=80=98vcpu_has_feature=E2=80=99; did you mean =E2=80=98cpu_have_fea=
ture=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>    29 |         if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2)) {
>                  |             ^~~~~~~~~~~~~~~~
>                                |             cpu_have_feature
>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
> ---
>  include/kvm/arm_psci.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> index f86a006d67136..06c20612e9e7d 100644
> --- a/include/kvm/arm_psci.h
> +++ b/include/kvm/arm_psci.h
> @@ -10,6 +10,8 @@
>  #include <linux/kvm_host.h>
>  #include <uapi/linux/psci.h>
>
> +#include <asm/kvm_emulate.h>
> +
>  #define KVM_ARM_PSCI_0_1       PSCI_VERSION(0, 1)
>  #define KVM_ARM_PSCI_0_2       PSCI_VERSION(0, 2)
>  #define KVM_ARM_PSCI_1_0       PSCI_VERSION(1, 0)
> --
> 2.43.0
>
