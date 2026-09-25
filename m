Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F12049C4BC
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 15:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790350494; cv=pass; b=oYz5jB/AemumFuf5NNUrto149NSoWUMglkfrtKgzSDU+0ZImn3cw5ucfuRguUsqR1hhyitFW6PMEKHnktTYG3lOYKW1FZpisvTnB+Sw79nI+qnpikam/jDV6DK+1fLAkOiGIyg1Dbw4ST04XCHaRPixO/YelleBBYhHL0wOmSFQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790350494; c=relaxed/simple;
	bh=c4skHotUrohj5tY649YiUgljNI4R9MsOmUhNsuTt4mw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KB+0Dyr+HKW1C0R0J3D4HyT4tmvjv1WgbCYIAcaY/niap0cKEAFav0Jn+rsrHznFg0EX8L9uwcEdzppTjoPNvfcynhIDo0X9rXE0YJwkHeSzj1+pIByDvTuK3RK/s/rbniAA2MYh4oIbi4JiEKv3IXVs13PEEAoKzFmxOqOwiZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i/JG8gyH; arc=pass smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i/JG8gyH"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b8e6ec4e0bso731147e87.1
        for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 08:34:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790350490; cv=none;
        d=google.com; s=arc-20260327;
        b=Z4Q0/zWozFjZ8TqzuIX71r4xrQPXjFiqR4LJeqXzVBrlxSPcbmqyfTcMRL3TellW+D
         uLygGvBH9GqkUqRTEeHSo3RM8xW9ORcCRElZEfejQQQAwvNeKyNEZbqNCtaSuBK5PgO1
         P8ZCQM58GoZ38mTXJdDRQcVQ2sO4ZaXPQOhO0RpDo5UGT7cMBzGV8N0d00oi5EbLGZPx
         5V1P1ZUVMFvaZ9e/iu6qqwZkLwhdVpUgkGevAaCluq1xumfehUHDUR9HUdFto81Yw5vA
         7YrrVCZyMXvzv/QCBzo+6z9DmdJMBYOg9SZzk4kyU5m2N74Shu2rAPhTJFT8LaxbEpLK
         PYZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LvgREEEhLtnlSAa2TqV+iSmo5cysotPSfNcR8BHubB4=;
        fh=Oe7h+plfEZxeOrDRcTny49Sshb//2rUAIWG/zKgpZUU=;
        b=XEnnD1ip8zKiToVaJ+stai+z6ZzX6WbV5j/JhbitKFGrqDDG4yWj/kWDgU11YYl5h8
         sNVNONmCvmzmqKbhqwfUPwrXgxvtKUuFhSP/c4/YgUlf9wJkZYb5HyLw91qNLVKP91CT
         lbzXj7K3Rnn/CY/HxCKqRZwbxG2c/2ONAKGWkXXbttkOH8BJ4neDwcpeCbVvAc0lNkEO
         J2BJ40Wl1lWJ5lUE83cgAEPfcXTHYKTaLqUMmUSY+Q1s5nw2CEtrJXBk0vPugkyZcL/L
         PN/t6OPqVSpx71ZAlaE0u1O9rvtWeT357sjcVbAI7m7bEA5Y2sjhpP9j3NoOatF47kJ+
         P8qQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790350490; x=1790955290; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LvgREEEhLtnlSAa2TqV+iSmo5cysotPSfNcR8BHubB4=;
        b=i/JG8gyHaV6XQSEHoKvLF20nZY3GTLv/IxdajOeFx/gu5qY2uJfoKM+bz9Y3esotl7
         /RilEM5K4auKuYaDc5+Glzmq4UEpQgFysouXSuWgJdqZ1sW7zIvWFAHz3x88eyTNMGEX
         JEf0D6NQxssSsEToIEkJroxY7Fa0r6SFhj2e2tUuRoBUm42f1oLAC2y/ITRvgetMbaWa
         E/DwSOfrLKOmEXKLy8CBQSQF2luvkR5+WyV+3ySVKfWw0uBhCIMn3PHNx8iiBE6rek8f
         awSnsbDYiupaZ89/A5RgxpvEdoh134AU0EB8y55QhYYhjuqz/K62G4BsBPrtyYo1SOO2
         aKKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790350490; x=1790955290;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LvgREEEhLtnlSAa2TqV+iSmo5cysotPSfNcR8BHubB4=;
        b=a0thMBIx7x9HPk1ypRSXHswM8LDr5sN8/+tn8xXBE70ZO/ZRP/vxnaCwm2om2K81hI
         6IjJXyciV0BlR9R6TCj4EAMR6gva1Tyau3i+jvQTyiFYdUyKfk9KQ8HtpfMiX0zN2GOs
         usRdrhidREW9nMXhUxtC4wdhScOxPmf+HGEUKc9VRwqiYweBwvfEs8GMn/P6jXcKoyWW
         ak+F6buJNDOE4hw85PuymXK5o0qzOIt8d8AX/IQMtc1JM2v36+YR4i6uJzRh5EGwu/7R
         a6wtVOQ3n/Xa3QUhUciqMOB1xPZ4ouhE48LZAunsi7PHTzLlSnsWvFHj+kCl+BINpR81
         9tkg==
X-Forwarded-Encrypted: i=1; AKwUvBwr+m/LiqSPetcyyyZ2zE5KKpPJRRZlfDu2zXDv5Ehc/jBlaXQqyk/hQxRziyT7WsYzMLC2BLI=@lists.linux.dev
X-Gm-Message-State: AFuF++kAuZ19xWRVsdxVn+Po2cJ5wmqszcUKLNOnQ+m0h60gATlUzKRj
	y6mzOD0wiEfy1iotDpdppeXrI8rfayUGRgtADD/CxQWrWi8dbN60iTlczEMiPl0ceQAdc5hhDwj
	e52qsIX9w/szdZ4fFu/xd1x3cMe8nAF87yLfbGMYf
X-Gm-Gg: AYBFou0EFHE0EU3vYFlk+LHy1DLtq7QFnICVgxw1ybhyy3ODSgautMYltzfML+sapz+
	Agoi0tTv7z7hCbt5ZfCEJzK3aHtepuviSF/O0HVUWdDBIcQEvwKa4Tp0GWYktP7Buw1EmZ/vzXi
	lTj8OkqZ9BB2WnO6Fte2d77BPPyLR3t0U7VXFagpXXNh40zjFGndshvLS/C/wLVtx2jU1knexiV
	XeRPVinv0eLSuh9dn2ooKErOtgvC59HTRsH+oCB8eGDbmK9fmph9Xqsy9D6TfYmxwqL+DBkDFiK
	0LG0VbrQ+rC2K3L5ObxXaV+C9QLOkErt4UcV6tfbcpz0Lq8i8xwnqw==
X-Received: by 2002:a05:6512:118c:b0:5b7:5142:d495 with SMTP id
 2adb3069b0e04-5b8df085af7mr1904494e87.64.1790350489353; Fri, 25 Sep 2026
 08:34:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-6-suzuki.poulose@arm.com> <arZmXFw5Jw2IbAmA@arm.com> <a11aba04-eaaa-43fd-988b-a2581b1b2fdb@arm.com>
In-Reply-To: <a11aba04-eaaa-43fd-988b-a2581b1b2fdb@arm.com>
From: Alper Gun <alpergun@google.com>
Date: Fri, 25 Sep 2026 08:34:37 -0700
X-Gm-Features: AclHuK8ZdVRdb_V4naZFOsXJSH2Fz3e3v_5J12YbiSGiHDcQI7elXhO9Nk5iNy0
Message-ID: <CABpDEu=Dmo6+KpkYwRwYyCWtKjazJvTktVQh6d+2sUM3AchHbg@mail.gmail.com>
Subject: Re: [PATCH v19 5/7] firmware: arm_rmm: Activate the RMM
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	maz@kernel.org, will@kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com, 
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com, 
	sdonthineni@nvidia.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com, 
	jonathan.cameron@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 25, 2026 at 8:02=E2=80=AFAM Suzuki K Poulose <suzuki.poulose@ar=
m.com> wrote:
[...]
> Kdump may be a bit more easier, as the kdump kernel is supposed to use
> the "reserved" region and vmcore access could handle the GPF and
> provide "0"s to the reader ? May be this is one case where the
> host needs to be able to handle GPFs.

I've tested kdump on CCA hardware with a running Realm VM and hit
GPF 0x28 in copy_oldmem_page() when reading pages delegated for
RMM/Realm metadata.
Since do_gpf() already runs fixup_exception(), using
copy_from_kernel_nofault() and falling back to iov_iter_zero() in
copy_oldmem_page() fixes it.

Here is the fix I've tested for the v16 CCA series.


diff --git a/arch/arm64/kernel/crash_dump.c b/arch/arm64/kernel/crash_dump.=
c
index 670e4ce81822..b0ab22293aa9 100644
--- a/arch/arm64/kernel/crash_dump.c
+++ b/arch/arm64/kernel/crash_dump.c
@@ -6,16 +6,28 @@
  * Author: AKASHI Takahiro <takahiro.akashi@linaro.org>
  */

+#include <linux/cpufeature.h>
 #include <linux/crash_dump.h>
 #include <linux/errno.h>
+#include <linux/gfp.h>
 #include <linux/io.h>
+#include <linux/uaccess.h>
 #include <linux/uio.h>
 #include <asm/memory.h>

+static bool system_has_rme(void)
+{
+ u64 pfr0 =3D read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+
+ return cpuid_feature_extract_unsigned_field(pfr0,
+    ID_AA64PFR0_EL1_RME_SHIFT);
+}
+
 ssize_t copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
  size_t csize, unsigned long offset)
 {
  void *vaddr;
+ void *buf;

  if (!csize)
  return 0;
@@ -24,8 +36,31 @@ ssize_t copy_oldmem_page(struct iov_iter *iter,
unsigned long pfn,
  if (!vaddr)
  return -ENOMEM;

- csize =3D copy_to_iter(vaddr + offset, csize, iter);
+ if (!system_has_rme()) {
+ csize =3D copy_to_iter(vaddr + offset, csize, iter);
+ memunmap(vaddr);
+ return csize;
+ }
+
+ buf =3D (void *)__get_free_page(GFP_KERNEL);
+ if (!buf) {
+ memunmap(vaddr);
+ return -ENOMEM;
+ }
+
+ /*
+ * Pages delegated to the Realm Management Monitor (RMM) or Root
+ * world trigger a synchronous Granule Protection Fault (GPF) when
+ * read from the Non-Secure crash kernel. Use copy_from_kernel_nofault()
+ * so the exception table catches the GPF and fall back to zero-filling
+ * the inaccessible granule.
+ */
+ if (copy_from_kernel_nofault(buf, vaddr + offset, csize))
+ csize =3D iov_iter_zero(csize, iter);
+ else
+ csize =3D copy_to_iter(buf, csize, iter);

+ free_page((unsigned long)buf);
  memunmap(vaddr);

  return csize;
