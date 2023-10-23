Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B619F224C9
	for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 19:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a0SyXovJ"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-53e751aeb3cso5666316a12.2
        for <kvmarm@lists.linux.dev>; Mon, 23 Oct 2023 12:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698089434; x=1698694234; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OOWHyp1apMK593shU2MRuweL3LwvBPDQ0MBY19ARFVk=;
        b=a0SyXovJmEUyxvk6ldgbftgDsszsJGsijAxEO6BO12xIBwuMGxj4fOry6lXiSz68BH
         sDmbGsyb1kDD4BubBkYEGXOYtNZGW4FdZvkTkqLNfWqGDNrL934AgBsZlJAhgHhE20HC
         7q+u6LzNnxBbKmS1UeaN8fx/7BiDl7lLoT4bYCLgDVH7FFZwXRO/OKjUaRr/WwB0vhK4
         Arnav8JpR2UWY6i0XVxpSRiXLEZ+5ddiZZIG/OPArnv7b8seE+Ua3vbmY7XA27AYS4K9
         UgsezZh9NukLRlBIv7xwUqICzFK0vi8KtEvWn7npZG0QxJ6dDYmixOGnEnLI4w8CGVkP
         VMxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698089434; x=1698694234;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OOWHyp1apMK593shU2MRuweL3LwvBPDQ0MBY19ARFVk=;
        b=c/ENNJjO+fVJprKDVRrbSBK//DyGxDcwlnNv/i3Y6bpdsuNexGBBac/SGnilA4dLg4
         cmy4v8pH9RWtqFXuDWPS+ISgrd9Bz3vMjBurK7G/8Ad092wHPNt5SRmqK/2qkUrAMj4b
         AxfZb8rymm4IkpWjHXbDoNYPSkGWOIhQBvmaYcTJekW7N74WEfLN2Gxr9SXCVqjT57Eu
         5cC1lGt9LlXkOquGwsGDqau+fxTMxlkdaNAVCTaP45NnO2XSkb1Ztf1qeNrLZNwDPNVo
         KGNgh4JR5ugG+CUDOm67KDJs/hTg0GgiNHap4fFzDuFDPpe2eaVd4kiBpy/ipAoPgvbY
         jN/w==
X-Gm-Message-State: AOJu0YznNIrjWbb8J+a2RzYdwaz/WCJlnpQMk7MTBcNOu5VNOkMRBE7z
	wQgYljv8pK8EKJAXl1jk+sC+reMmwB/HYq/ZUQ==
X-Google-Smtp-Source: AGHT+IHtPEwEdv1R67ewmN3QjN2VewaqNbQmgLSCiAxqY2PPO146bleLuad9tzy+WrA1JY7N0hp+P6s9/af35JMl/6M=
X-Received: by 2002:a50:d502:0:b0:53e:4c39:5608 with SMTP id
 u2-20020a50d502000000b0053e4c395608mr7381578edi.17.1698089433624; Mon, 23 Oct
 2023 12:30:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAC=5qx_EDYCifRGNbXaJ96psuqQ-Y7zw8O_V_q-_kYpkuD52RQ@mail.gmail.com>
 <20231023141639.GA3779@willie-the-truck>
In-Reply-To: <20231023141639.GA3779@willie-the-truck>
From: KVMR <kvmrdy@gmail.com>
Date: Tue, 24 Oct 2023 01:00:22 +0530
Message-ID: <CAC=5qx-Qq8+fzONjYCvEyUe4g+bZiMM80rfy3niyw-4xqZYf5g@mail.gmail.com>
Subject: Re: pKVM: Which kernel version has support for pKVM?
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Will,

Thank you very much for your response.

Regarding the test cases, I would like to see if you utilized any
scripts or programs to validate the features. For instance, I'm
interested in understanding how memory protection between the VM and
the Host was verified. Did you automate the verification process? For
instance, did you employ /proc/<pid>/mem or any other methods? I will
check the Android CTS for similar test cases.

Additionally, I'd like to know if Crosvm VMM provides full support for
pKVM. As mentioned in the 'AVF architecture' documentation, I used
'Crosvm' from https://chromium.googlesource.com/crosvm/crosvm and
successfully launched a protected VM with a Rootfs as initrd. However,
I encountered an issue when trying to launch it as a block device
(virtio-blk). The following command failed:

```
crosvm run -r rootfs.ext4 --protected-vm-without-firmware --no-balloon
--cpus 1 --mem 1024 Image
```

The error message I received was:

```
[*** ERROR crosvm::crosvm::sys::linux] child pcivirtio-block (pid 829)
exited: signo 17, status 11, code 2
[*** ERROR devices::proxy] failed write to child device process
pcivirtio-block: failed to send packet: Broken pipe (os error 32)
```

Is there a need for further modifications or updates to Crosvm's
Virtio drivers to ensure full pKVM support or is my usage wrong?

Thanks and regards,
Venkat


On Mon, Oct 23, 2023 at 7:46=E2=80=AFPM Will Deacon <will@kernel.org> wrote=
:
>
> Hi Venkat [+Fuad],
>
> On Wed, Oct 11, 2023 at 09:10:19AM +0530, KVMR wrote:
> > We are interested in using Protected KVM (pKVM) in one of our
> > projects. Our goal is to launch protected VMs on Linux with KVM,
> > ARM64. We have a few queries and would appreciate your assistance in
> > addressing them:
> >
> > 1. We'd like to know which mainline kernel version offers complete
> > support for pKVM. We've observed that the current TOT kernel (6.6.rc5)
> > may not have all the necessary changes. Specifically, we couldn't
> > locate the KVM_CAP_ARM_PROTECTED_VM symbol in the code. If all the
> > required changes have not yet been merged into the mainline kernel,
> > could you please provide information on the specific branch or
> > repository that contains these changes?
>
> Upstreaming is currently blocked on support for the guestmem series [1],
> but you can look at our integration branch at [2] which has everything
> based on the last kernel release.
>
> > 2. Are there any additional changes planned for pKVM, and is there a
> > roadmap page where we can find more information on the project's
> > future developments?
>
> It's mainly driven by the Android annual roadmap, since that's still
> the driving force behind pKVM.
>
> > 3. In order to verify the pKVM memory protection features, we are
> > seeking readily available test cases. Could you guide us to where we
> > can find such test cases for this purpose?
>
> We have high-level tests integrated with the Android CTS, but I'm not sur=
e
> whether that's what you're after.
>
> Will
>
> [1] https://lore.kernel.org/all/20230914015531.1419405-1-seanjc@google.co=
m/
> [2] https://android-kvm.googlesource.com/linux/+/refs/heads/for-upstream/=
pkvm-integration
