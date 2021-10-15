Return-Path: <SRS0=NFrk=PE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CAECC433EF
	for <kvmarm@archiver.kernel.org>; Sat, 16 Oct 2021 09:30:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 97C9E61244
	for <kvmarm@archiver.kernel.org>; Sat, 16 Oct 2021 09:30:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 97C9E61244
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDB9C4B0DB;
	Sat, 16 Oct 2021 05:30:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rM-qFdI6N9P7; Sat, 16 Oct 2021 05:30:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 135C64B12F;
	Sat, 16 Oct 2021 05:30:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DBEA4B12E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 11:12:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TctmXnR51E+o for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Oct 2021 11:12:01 -0400 (EDT)
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com
 [209.85.222.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F2954B102
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 11:12:01 -0400 (EDT)
Received: by mail-ua1-f43.google.com with SMTP id r22so7835692uat.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 08:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=55zlp2eAbdtH37f5TfIjC5fLBXxDZKtIEF8K8lsz0Y0=;
 b=FvK5NQ6SguLuyY+ZqhuHGlMn2FXz6ViqncpfwojNJasUzPF6CgDKsq7ssGd1T1KZwt
 fib8NSiptWGnKN3JLPmePcl689ARybfpZ/g5XpAHq5FKPrT/h5F2Nrrg4AKW5aH+3XCv
 Zo/tetFUFZ5yUI9/w6oXLJJe7n46zo7L28iJYp+Q+HJwZPlrUizYIZULhGbengf8XokE
 +jg8PMT1alfiS1OcTqtzA9bkmvS1Ll/XAVYr6pb9sZiPwmNXMeA3RAGrUvDkc+HSxpCY
 /U3oxo88eh7RSq7/Mc6CkmqPpdJrO4+BxSw8NvRzlMq8dUg3mWGBUbkuBT6B2VUJ4T0X
 q9qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=55zlp2eAbdtH37f5TfIjC5fLBXxDZKtIEF8K8lsz0Y0=;
 b=n3KwdCidTgVyFX/KHSR6W2zW+ke1z/Sfa8kbLT8y4t+xb6TIAm+WIIw2RnhOPSEkbg
 MCgO0hjk22kVTCM276VLcjz3y8TO+NbgIJqmvBubOFNq/Vv2bAhbmO+9aEeDI9MHWURl
 u1/ESr5AM914fu5JbT4st8sfifeHYWH0ynQu491bDNhmbNrXzbcMLKNxj+Yf9GxD/GLg
 E/To/UABFILmMJIuRE4mAHxl5n+vw8UzER+Mk14ijhiJVp9+rBwwHc1UokY6k8j1J558
 HB7zwlD28QDp3A3XjxVdDfpNwedw5X3l8gY5P7RBHH4stbPep3hvSFGCQDkmaki29XuL
 piCg==
X-Gm-Message-State: AOAM530tlq6tTe/S8kR0jsI1LqvwoZI5ASbS+AYUaFHo/wDxtM48hOHM
 N/dLkbci08qTEWAYuGR2lZN0sUoYkmNPtDqqM4QP3g==
X-Google-Smtp-Source: ABdhPJyow0MyrI0Nn++XrwlvL6E3qAPY6ccHmXMFOkMVTAo5A3PhWm8x5FCMpah9bMR/1f/j19S/hUtGFnlXYS0NG4Y=
X-Received: by 2002:a67:7284:: with SMTP id n126mr14261283vsc.26.1634310720731; 
 Fri, 15 Oct 2021 08:12:00 -0700 (PDT)
MIME-Version: 1.0
References: <20211013155831.943476-1-qperret@google.com>
 <20211013155831.943476-2-qperret@google.com>
In-Reply-To: <20211013155831.943476-2-qperret@google.com>
From: Andrew Walbran <qwandor@google.com>
Date: Fri, 15 Oct 2021 16:11:49 +0100
Message-ID: <CA+_y_2HnBqL4wSzxLMwxONj4wMMDT15wOAieb6moN0q474=ENQ@mail.gmail.com>
Subject: Re: [PATCH 01/16] KVM: arm64: Introduce do_share() helper for memory
 sharing between components
To: Quentin Perret <qperret@google.com>
X-Mailman-Approved-At: Sat, 16 Oct 2021 05:30:45 -0400
Cc: Android Kernel Team <kernel-team@android.com>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2766097692401117916=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============2766097692401117916==
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000fe400705ce659d06"

--000000000000fe400705ce659d06
Content-Type: text/plain; charset="UTF-8"

On Wed, 13 Oct 2021 at 16:58, 'Quentin Perret' via kernel-team
<kernel-team@android.com> wrote:
>
> From: Will Deacon <will@kernel.org>
>
> In preparation for extending memory sharing to include the guest as well
> as the hypervisor and the host, introduce a high-level do_share() helper
> which allows memory to be shared between these components without
> duplication of validity checks.
>
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   5 +
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 315 ++++++++++++++++++
>  2 files changed, 320 insertions(+)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index b58c910babaf..56445586c755 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -24,6 +24,11 @@ enum pkvm_page_state {
>         PKVM_PAGE_OWNED                 = 0ULL,
>         PKVM_PAGE_SHARED_OWNED          = KVM_PGTABLE_PROT_SW0,
>         PKVM_PAGE_SHARED_BORROWED       = KVM_PGTABLE_PROT_SW1,
> +       __PKVM_PAGE_RESERVED            = KVM_PGTABLE_PROT_SW0 |
> +                                         KVM_PGTABLE_PROT_SW1,
> +
> +       /* Meta-states which aren't encoded directly in the PTE's SW bits */
> +       PKVM_NOPAGE,
>  };
>
>  #define PKVM_PAGE_STATE_PROT_MASK      (KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index bacd493a4eac..53e503501044 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -443,3 +443,318 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
>         ret = host_stage2_idmap(addr);
>         BUG_ON(ret && ret != -EAGAIN);
>  }
> +
> +/* This corresponds to locking order */
> +enum pkvm_component_id {
> +       PKVM_ID_HOST,
> +       PKVM_ID_HYP,
> +};
> +
> +struct pkvm_mem_transition {
> +       u64                             nr_pages;
> +
> +       struct {
> +               enum pkvm_component_id  id;
> +               u64                     addr;
Is this the physical address or the IPA of the initiator? It would be
good to have a comment explaining.

> +
> +               union {
> +                       struct {
> +                               u64     completer_addr;
> +                       } host;
> +               };
> +       } initiator;
> +
> +       struct {
> +               enum pkvm_component_id  id;
> +       } completer;
> +};
> +
> +struct pkvm_mem_share {
> +       struct pkvm_mem_transition      tx;
> +       enum kvm_pgtable_prot           prot;
> +};
> +
> +struct pkvm_page_req {
> +       struct {
> +               enum pkvm_page_state    state;
> +               u64                     addr;
> +       } initiator;
> +
> +       struct {
> +               u64                     addr;
> +       } completer;
> +
> +       phys_addr_t                     phys;
> +};
> +
> +struct pkvm_page_share_ack {
> +       struct {
> +               enum pkvm_page_state    state;
> +               phys_addr_t             phys;
> +               enum kvm_pgtable_prot   prot;
> +       } completer;
> +};
> +
> +static void host_lock_component(void)
> +{
> +       hyp_spin_lock(&host_kvm.lock);
> +}
> +
> +static void host_unlock_component(void)
> +{
> +       hyp_spin_unlock(&host_kvm.lock);
> +}
> +
> +static void hyp_lock_component(void)
> +{
> +       hyp_spin_lock(&pkvm_pgd_lock);
> +}
> +
> +static void hyp_unlock_component(void)
> +{
> +       hyp_spin_unlock(&pkvm_pgd_lock);
> +}
> +
> +static int host_request_share(struct pkvm_page_req *req,
> +                             struct pkvm_mem_transition *tx,
> +                             u64 idx)
> +{
> +       u64 offset = idx * PAGE_SIZE;
> +       enum kvm_pgtable_prot prot;
> +       u64 host_addr;
> +       kvm_pte_t pte;
> +       int err;
> +
> +       hyp_assert_lock_held(&host_kvm.lock);
> +
> +       host_addr = tx->initiator.addr + offset;
> +       err = kvm_pgtable_get_leaf(&host_kvm.pgt, host_addr, &pte, NULL);
> +       if (err)
> +               return err;
> +
> +       if (!kvm_pte_valid(pte) && pte)
> +               return -EPERM;
> +
> +       prot = kvm_pgtable_stage2_pte_prot(pte);
> +       *req = (struct pkvm_page_req) {
> +               .initiator      = {
> +                       .state  = pkvm_getstate(prot),
> +                       .addr   = host_addr,
> +               },
> +               .completer      = {
> +                       .addr   = tx->initiator.host.completer_addr + offset,
> +               },
> +               .phys           = host_addr,
> +       };
> +
> +       return 0;
> +}
> +
> +/*
> + * Populate the page-sharing request (@req) based on the share transition
> + * information from the initiator and its current page state.
> + */
> +static int request_share(struct pkvm_page_req *req,
> +                        struct pkvm_mem_share *share,
> +                        u64 idx)
> +{
> +       struct pkvm_mem_transition *tx = &share->tx;
> +
> +       switch (tx->initiator.id) {
> +       case PKVM_ID_HOST:
> +               return host_request_share(req, tx, idx);
> +       default:
> +               return -EINVAL;
> +       }
> +}
> +
> +static int hyp_ack_share(struct pkvm_page_share_ack *ack,
> +                        struct pkvm_page_req *req,
> +                        enum kvm_pgtable_prot perms)
> +{
> +       enum pkvm_page_state state = PKVM_NOPAGE;
> +       enum kvm_pgtable_prot prot = 0;
> +       phys_addr_t phys = 0;
> +       kvm_pte_t pte;
> +       u64 hyp_addr;
> +       int err;
> +
> +       hyp_assert_lock_held(&pkvm_pgd_lock);
> +
> +       if (perms != PAGE_HYP)
> +               return -EPERM;
> +
> +       hyp_addr = req->completer.addr;
> +       err = kvm_pgtable_get_leaf(&pkvm_pgtable, hyp_addr, &pte, NULL);
> +       if (err)
> +               return err;
> +
> +       if (kvm_pte_valid(pte)) {
> +               state   = pkvm_getstate(kvm_pgtable_hyp_pte_prot(pte));
> +               phys    = kvm_pte_to_phys(pte);
> +               prot    = kvm_pgtable_hyp_pte_prot(pte) & KVM_PGTABLE_PROT_RWX;
> +       }
> +
> +       *ack = (struct pkvm_page_share_ack) {
> +               .completer      = {
> +                       .state  = state,
> +                       .phys   = phys,
> +                       .prot   = prot,
> +               },
> +       };
> +
> +       return 0;
> +}
> +
> +/*
> + * Populate the page-sharing acknowledgment (@ack) based on the sharing request
> + * from the initiator and the current page state in the completer.
> + */
> +static int ack_share(struct pkvm_page_share_ack *ack,
> +                    struct pkvm_page_req *req,
> +                    struct pkvm_mem_share *share)
> +{
> +       struct pkvm_mem_transition *tx = &share->tx;
> +
> +       switch (tx->completer.id) {
> +       case PKVM_ID_HYP:
> +               return hyp_ack_share(ack, req, share->prot);
> +       default:
> +               return -EINVAL;
> +       }
> +}
> +
> +/*
> + * Check that the page states in the initiator and the completer are compatible
> + * for the requested page-sharing operation to go ahead.
> + */
> +static int check_share(struct pkvm_page_req *req,
> +                      struct pkvm_page_share_ack *ack,
> +                      struct pkvm_mem_share *share)
> +{
> +       if (!addr_is_memory(req->phys))
> +               return -EINVAL;
> +
> +       if (req->initiator.state == PKVM_PAGE_OWNED &&
> +           ack->completer.state == PKVM_NOPAGE) {
> +               return 0;
> +       }
> +
> +       if (req->initiator.state != PKVM_PAGE_SHARED_OWNED)
> +               return -EPERM;
> +
> +       if (ack->completer.state != PKVM_PAGE_SHARED_BORROWED)
> +               return -EPERM;
> +
> +       if (ack->completer.phys != req->phys)
> +               return -EPERM;
> +
> +       if (ack->completer.prot != share->prot)
> +               return -EPERM;
I guess this is the workaround you mentioned for the fact that the
host can share the same page twice? It might be worth adding a comment
to explain that that's what's going on.

> +
> +       return 0;
> +}
> +
> +static int host_initiate_share(struct pkvm_page_req *req)
> +{
> +       enum kvm_pgtable_prot prot;
> +
> +       prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, PKVM_PAGE_SHARED_OWNED);
> +       return host_stage2_idmap_locked(req->initiator.addr, PAGE_SIZE, prot);
> +}
> +
> +/* Update the initiator's page-table for the page-sharing request */
> +static int initiate_share(struct pkvm_page_req *req,
> +                         struct pkvm_mem_share *share)
> +{
> +       struct pkvm_mem_transition *tx = &share->tx;
> +
> +       switch (tx->initiator.id) {
> +       case PKVM_ID_HOST:
> +               return host_initiate_share(req);
> +       default:
> +               return -EINVAL;
> +       }
> +}
> +
> +static int hyp_complete_share(struct pkvm_page_req *req,
> +                             enum kvm_pgtable_prot perms)
> +{
> +       void *start = (void *)req->completer.addr, *end = start + PAGE_SIZE;
> +       enum kvm_pgtable_prot prot;
> +
> +       prot = pkvm_mkstate(perms, PKVM_PAGE_SHARED_BORROWED);
> +       return pkvm_create_mappings_locked(start, end, prot);
> +}
> +
> +/* Update the completer's page-table for the page-sharing request */
> +static int complete_share(struct pkvm_page_req *req,
> +                         struct pkvm_mem_share *share)
> +{
> +       struct pkvm_mem_transition *tx = &share->tx;
> +
> +       switch (tx->completer.id) {
> +       case PKVM_ID_HYP:
> +               return hyp_complete_share(req, share->prot);
> +       default:
> +               return -EINVAL;
> +       }
> +}
> +
> +/*
> + * do_share():
> + *
> + * The page owner grants access to another component with a given set
> + * of permissions.
> + *
> + * Initiator: OWNED    => SHARED_OWNED
> + * Completer: NOPAGE   => SHARED_BORROWED
> + *
> + * Note that we permit the same share operation to be repeated from the
> + * host to the hypervisor, as this removes the need for excessive
> + * book-keeping of shared KVM data structures at EL1.
> + */
> +static int do_share(struct pkvm_mem_share *share)
> +{
> +       struct pkvm_page_req req;
> +       int ret = 0;
> +       u64 idx;
> +
> +       for (idx = 0; idx < share->tx.nr_pages; ++idx) {
> +               struct pkvm_page_share_ack ack;
> +
> +               ret = request_share(&req, share, idx);
> +               if (ret)
> +                       goto out;
> +
> +               ret = ack_share(&ack, &req, share);
> +               if (ret)
> +                       goto out;
> +
> +               ret = check_share(&req, &ack, share);
> +               if (ret)
> +                       goto out;
> +       }
> +
> +       for (idx = 0; idx < share->tx.nr_pages; ++idx) {
> +               ret = request_share(&req, share, idx);
> +               if (ret)
> +                       break;
> +
> +               /* Allow double-sharing by skipping over the page */
> +               if (req.initiator.state == PKVM_PAGE_SHARED_OWNED)
> +                       continue;
> +
> +               ret = initiate_share(&req, share);
> +               if (ret)
> +                       break;
> +
> +               ret = complete_share(&req, share);
> +               if (ret)
> +                       break;
> +       }
> +
> +       WARN_ON(ret);
> +out:
> +       return ret;
> +}
> --
> 2.33.0.882.g93a45727a2-goog
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>

--000000000000fe400705ce659d06
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIPmgYJKoZIhvcNAQcCoIIPizCCD4cCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ggz0MIIEtjCCA56gAwIBAgIQeAMYYHb81ngUVR0WyMTzqzANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA3MjgwMDAwMDBaFw0yOTAzMTgwMDAwMDBaMFQxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFz
IFIzIFNNSU1FIENBIDIwMjAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCvLe9xPU9W
dpiHLAvX7kFnaFZPuJLey7LYaMO8P/xSngB9IN73mVc7YiLov12Fekdtn5kL8PjmDBEvTYmWsuQS
6VBo3vdlqqXZ0M9eMkjcKqijrmDRleudEoPDzTumwQ18VB/3I+vbN039HIaRQ5x+NHGiPHVfk6Rx
c6KAbYceyeqqfuJEcq23vhTdium/Bf5hHqYUhuJwnBQ+dAUcFndUKMJrth6lHeoifkbw2bv81zxJ
I9cvIy516+oUekqiSFGfzAqByv41OrgLV4fLGCDH3yRh1tj7EtV3l2TngqtrDLUs5R+sWIItPa/4
AJXB1Q3nGNl2tNjVpcSn0uJ7aFPbAgMBAAGjggGKMIIBhjAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFHzM
CmjXouseLHIb0c1dlW+N+/JjMB8GA1UdIwQYMBaAFI/wS3+oLkUkrk1Q+mOai97i3Ru8MHsGCCsG
AQUFBwEBBG8wbTAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3Ry
MzA7BggrBgEFBQcwAoYvaHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvcm9vdC1y
My5jcnQwNgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9yb290LXIz
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
NLKLRXC2UkITUqkLDDBMBgNVHSAERTBDMEEGCSsGAQQBoDIBKDA0MDIGCCsGAQUFBwIBFiZodHRw
czovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMIGaBggrBgEFBQcB
AQSBjTCBijA+BggrBgEFBQcwAYYyaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vY2EvZ3NhdGxh
c3Izc21pbWVjYTIwMjAwSAYIKwYBBQUHMAKGPGh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20v
Y2FjZXJ0L2dzYXRsYXNyM3NtaW1lY2EyMDIwLmNydDAfBgNVHSMEGDAWgBR8zApo16LrHixyG9HN
XZVvjfvyYzBGBgNVHR8EPzA9MDugOaA3hjVodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2NhL2dz
YXRsYXNyM3NtaW1lY2EyMDIwLmNybDANBgkqhkiG9w0BAQsFAAOCAQEAJZz81Ay9V97/pdWQKMlY
/Qku3gwyyzEfaZz7QTjClOWkncwBR4WF63koFYe6vpd9RBX1upBOk5vhr9n6mXjmLxLfxWqU/xsq
sIJJDk19oBSQvbt138wyZBe6UYYgQhQ3ZvU/9vTXB9geysqPfJbr27MYJ0ZFrCDlQdW49MksZ1x6
6lozqMEFN/tTBhma7G7hGCHF/4rP3XXH/o4f5ftfL23dA+4F9sPwugH2sjEt7Dn/7eCFhT4Hbf7/
P/Sxi49Xlra8e/bCTotvMPt76LN69+0lcZzcc/oNJJttsCLBqBZ7ABTSiTQaLp4UwTgTYMg7eBqD
oJF2uULm2EfP8cT7HzGCAmowggJmAgEBMGgwVDELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2Jh
bFNpZ24gbnYtc2ExKjAoBgNVBAMTIUdsb2JhbFNpZ24gQXRsYXMgUjMgU01JTUUgQ0EgMjAyMAIQ
AdV711V3BM5Q4YSSMDl1STANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg+Wh5pddd
lvQ58ROvZ7Vp62rEaNYcNBeUGmGTIExjaa8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjExMDE1MTUxMjAxWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBACngA3hh4oU/FBW4TTfnoTeS/CRw
hneqhDohxIlmscZtd7cGh4XCJd1nT6lSgienSWaGzXkw5t/Rf9boV3A6+xo0OsXngR0m821pV7yb
FbzNvEAm7sqtD7e+aOXfGKaIwYzRjom7PcxW2SSQFwvvQOkz00eYs+mfg3Qbu2BsaCP8S7MG6WCs
n6dSmHfHvs+V1PlUegwJYeASGrOo6NVJmyw6ycsyiuZbjwQ77S6QiOEAJ9DHXCGPbZ/MEfX2/gET
5i5ZkUymkB3zsgvAAjQmPmUE5GO0F5NQvW5uXlQqCTE+aQakv9ebAJLDWz9z1jqsiU1LFynqzTco
GomZKCEwIDM=
--000000000000fe400705ce659d06--

--===============2766097692401117916==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============2766097692401117916==--
